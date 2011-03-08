require 'spec_helper'
require 'zxing'

describe QREncoder do
  context "full integration" do
    shared_examples_for "decodable" do
      let(:message) { 'a message' }
      let(:path) do
        File.expand_path("../../tmp/integration.png", __FILE__)
      end
      before { File.unlink(path) if File.file?(path) }
      it "creates decodable QRCode png files" do
        QREncoder.encode(message).save_png(path)
        ZXing.decode(path).should == message
      end
    end
    it_should_behave_like "decodable" do
      let(:message) {"Oh my! I'm amazed by technology."}
    end
    it_should_behave_like "decodable" do
      let(:message) {"&*@ad!jlfj-=+"}
    end
  end
end
