require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Smells Like Fail" }
  describe "Home page" do

    it "should have the content 'Smells Like Fail'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Smells Like Fail')
    end

    it "should have the correct title" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "Smells Like Fail | Home")
    end
  end

  describe "About page" do

    it "should have the content 'About'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About')
    end
  	
  	it "should have the correct title" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "#{base_title} | About")
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the correct title" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "#{base_title} | Help")
    end
  end

  describe "Recruitment page" do

    it "should have the content 'Recruitment'" do
      visit '/static_pages/recruitment'
      page.should have_selector('h1', :text => 'Recruitment')
    end

    it "should have the correct title" do
      visit '/static_pages/recruitment'
      page.should have_selector('title', :text => "#{base_title} | Recruitment")
    end
  end
end