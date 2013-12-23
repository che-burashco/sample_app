require 'spec_helper'
include AlertMatchers

describe "User pages" do
  subject{page}
  describe "signup page" do
  	before {visit signup_path}

    let (:submit) { "Create my Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect{click_button submit}.not_to change(User, :count)
      end

      describe "after submission" do
        
        shared_examples_for "all submissions with invalid information" do
          it {should have_title("Sign Up")}
          it {should have_content("error")}
        end

        describe "with empty information" do
          before {click_button submit}
          it_should_behave_like "all submissions with invalid information"

          it {should have_content("Email can't be blank")}
          it {should have_content("Name can't be blank")}
          it {should have_content("Password can't be blank")}
        end

        describe "after submission with incorrect email" do
          before do
           fill_in "Name", with: "Example User"
           fill_in "Email", with: "user@example"
           fill_in "Password", with: "foobar"
           fill_in "Confirmation", with: "foobar"           
          end
          before {click_button submit}

          it_should_behave_like "all submissions with invalid information"
          it {should have_content("Email is invalid")}
          it {should_not have_content("Email can't be blank")}
          it {should_not have_content("Name can't be blank")}
          it {should_not have_content("Password can't be blank")}
          it {should_not have_content("Passwords don't match")}
        end

        describe "after submission with password that don't match" do
          before do
            fill_in "Name", with: "Example User"
            fill_in "Email", with: "user@example.com"
            fill_in "Password", with: "foobar"
            fill_in "Confirmation", with: "foobar1"
          end
          before {click_button submit}

          it_should_behave_like "all submissions with invalid information"
          it {should have_content("Password confirmation doesn't match")}
          it {should_not have_content("Email is invalid")}
          it {should_not have_content("Email can't be blank")}
          it {should_not have_content("Name can't be blank")}
          it {should_not have_content("Password can't be blank")}
        end    
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect{click_button submit}.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before{click_button submit}
        let(:user){User.find_by(email: "user@example.com")}

        it {should have_link('Sign out')}
        it {should have_title(user.name)}
        it {should have_success_message('Welcome')}

        describe "followed by sign out" do
          before{click_link "Sign out"}
          it {should have_link("Sign in")}
        end
      end
    end

    it {should have_content("Sign Up")}
    it {should have_title(full_title("Sign Up"))}

  end

  describe "profile page" do
  	let(:user){FactoryGirl.create(:user)}
  	before {visit user_path(user)}

  	it {should have_content(user.name)}
  	it {should have_title(user.name)}
  end
end
