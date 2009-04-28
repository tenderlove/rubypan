class FaqController < ApplicationController
  
  def index
    q_a = Faq.new
    @faqs = q_a.all 
  end

end
