require 'spec_helper'
require 'zxing'

describe QREncoder do
  context "integration" do
    let(:path) { File.expand_path("../../tmp/integration.png", __FILE__) }
    let(:options) { Hash.new }
    let(:png) { QREncoder.encode(message).png(options) }
    before do
      File.unlink(path) if File.file?(path)
      png.save(path)
    end

    subject { ZXing.decode(path) }

    context "with a sentence" do
      let(:message) {"Oh my! I'm amazed by technology."}
      it { should == message }
    end

    context "with ascii characters" do
      let(:message) {"&*@ad!jlfj-=+"}
      it { should == message }
    end

    context "with a custom pixel per module size" do
      let(:message) { "bigger" }
      let(:options) do
        { :pixels_per_module => 4 }
      end
      it { should == message }
      it "produces a larger png width and height" do
        png.width.should == 29 * 4
      end
    end
  end
end
