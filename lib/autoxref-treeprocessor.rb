# coding: utf-8
# autoxref-treeprocessor.rb: Automatic cross-reference generator.
#
# Copyright (c) 2016 Takahiro Yoshimura <altakey@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
require 'asciidoctor/extensions'

include Asciidoctor

Extensions.register do
  treeprocessor AutoXrefTreeprocessor
end

# A treeprocessor that allows refering sections and titled
# images/listings/tables with their reference number (e.g. Figure
# <chapter number>.1, <chapter number>.2, ... for images).
#
# Works by assigning reference number-based captions (RNBCs) for
# targets, and updates reference table in the document with them.
#
# Run using:
#
# asciidoctor -r ./lib/autoxref-treeprocessor.rb lib/autoxref-treeprocessor/sample.adoc
class AutoXrefTreeprocessor < Extensions::Treeprocessor
  def process document
    # The section level we should treat as chapters.
    chapter_section_level = (document.attr 'autoxref-chaptersectlevel', 1).to_i

    # Captions should we use.
    captions = {
      :example => (document.attr 'autoxref-examplecaption', (document.attr "example-caption") + " %d.%d"),
      :image => (document.attr 'autoxref-imagecaption', (document.attr "figure-caption") + " %d.%d"),
      :table => (document.attr 'autoxref-tablecaption', (document.attr "table-caption") + " %d.%d")
    }

    # Scan for chapters.
    document.find_by(context: :section).each do |chapter|
      next unless chapter.level == chapter_section_level && chapter.numbered
  
      # Reset our reference numbers.
      counter = {
        :example => 1,
        :image => 1,
        :table => 1
      }

      # Scan for sections, titled examples/images/tables in the chapter.
      [:example, :image, :table].each do |type| # :example, :image, 
        chapter.find_by(context: type).each do |el|
          # Generate RNBCs for eligible targets and update reference table in the document.  For non-sections, we also overwrite their captions with RNBCs.
          if el.title? then
            replaced = captions[type] % [chapter.number, get_and_tally_counter_of(type, counter)]
            replaced_caption = replaced + '. '
            el.caption = replaced_caption
            el.attributes['reftext'] = replaced
          end
        end
      end
    end
    nil
  end

  # Gets and increments the value for the given type in the given
  # counter.
  def get_and_tally_counter_of type, counter
    t = counter[type]
    counter[type] = counter[type] + 1
    t
  end

  # Retrieves the associated value for the given key. Lazily retrieve
  # default value if no attr is set on the given key.
  def attr_of target, key, &default
    begin
      (target.attr key, :none).to_i
    rescue NoMethodError
      if not default.nil? then default.call else 0 end
    end
  end
end
