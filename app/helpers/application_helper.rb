module ApplicationHelper
    
    def form_group_tag(errors, &block)
        # takes an array of errors and a block turned into a proc
        css_class = 'form-group'
        css_class << ' has-error' if errors.any?
        content_tag :div, capture(&block), class: css_class
        # content_tag helper takes 3 arguments
        # first is a symbol = creates an html tag
        # second is a block. & turns it into a proc
        # it creates the tag with the block contents
        # and the options hash
        # what does capture() do? execute the block and capture
        # any errors it throws? but it already has an errors
        # array?
    end
    
end
