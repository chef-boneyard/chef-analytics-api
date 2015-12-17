 #
 # Copyright:: Copyright (c) 2015 Chef Software, Inc.
 # License:: Apache License, Version 2.0
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #     http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 #

require 'spec_helper'

require 'chef-analytics/token_manager'

describe ChefAnalytics::TokenManager do
  let(:subject) { Class.new { extend ChefAnalytics::TokenManager } }
  let(:options) { {test: "options"} }
  context "get_identity" do
    it "returns an instance of ChefAnalytics::Identity" do
      expect(ChefAnalytics::Identity).to receive(:new).with(options)
      subject.get_identity_object(options)
    end
  end

  context "fetch_token" do
    let(:token) { true }
    let(:identity_object) { double("identity_object", :token => token) }
    before do
      allow(subject).to receive(:get_identity_object).and_return(identity_object)
    end

    context "when the token is a string" do
      let(:token) { "some_token" }
      it "returns the token" do
        expect(subject.fetch_token).to eq(token)
      end
    end

    context "when the token is nil" do
      let(:token) { nil }
      it "returns the token" do
        expect{subject.fetch_token}.to raise_error(ChefAnalytics::Exception::FetchTokenException)
      end
    end
  end
end
