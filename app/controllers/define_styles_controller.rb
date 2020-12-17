class DefineStylesController < ApplicationController
  def define_style
    @bibliographic_description = params[:text]
    # @bibliographic_description = "Lastname, L., Lasty2, N. (2020). Title: Subtitle text. Kyiv: Publisher1."

    # @style = BibDescription::BibDescriptionParser.parse(@text)
    result1 = BibDescription::BibDescriptionParser.get_rule(@bibliographic_description)
    @style = result1[:style]
    @link = style_link
    @result = result1[:result]
    @render_result = true

    render :define
  end

  private

  def style_link
    case @style
    when 'apa'
      '/bibliographic_styles/apa'
    when 'mla'
      '/bibliographic_styles/mla'
    when 'harvard'
      '/bibliographic_styles/harvard'
    when 'chicago'
      '/bibliographic_styles/chicago'
    when 'dstu'
      '/bibliographic_styles/dstu'
    else
      "Error: invalid style (#{@style})"
    end
  end
end