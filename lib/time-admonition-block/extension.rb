require 'asciidoctor/extensions'

include Asciidoctor

class TimeAdmonitionBlock < Extensions::BlockProcessor
  use_dsl
  named :TIME
  on_contexts :example, :paragraph

  def process parent, reader, attrs
    attrs['name'] = 'time'
    attrs['caption'] = 'Time'
    create_block parent, :admonition, reader.lines, attrs, content_model: :compound
  end
end

class TimeAdmonitionBlockDocinfo < Extensions::DocinfoProcessor
  use_dsl

  def process doc
    if (doc.basebackend? 'html') && doc.backend != 'pdf'
      '<style>
.admonitionblock td.icon .icon-time:before {content:"\f017";color:#f28500;}
</style>'
    end
  end
end
