# See: https://github.com/asciidoctor/asciidoctor-extensions-lab/blob/master/lib/custom-admonition-block.rb
RUBY_ENGINE == 'opal' ? (require 'time-admonition-block/extension') : (require_relative 'time-admonition-block/extension')

Extensions.register do
  block TimeAdmonitionBlock
  docinfo_processor TimeAdmonitionBlockDocinfo
end
