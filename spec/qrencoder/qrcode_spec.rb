require 'spec_helper'
require 'fixtures'

describe QREncoder::QRCode do

  describe "#data" do
    context "with default options and 'String'" do
      subject { QREncoder.encode("String").data }
      it { should be_kind_of(Array) }
      it "generates the correct data array" do
        subject.should == QREncoder::Fixtures::String1
      end
    end
  end

  describe "#dup" do
    subject { QREncoder.encode("something").dup }
    its(:width) { should == 21 }
  end

  describe "#width" do
    subject { QREncoder.encode("something").width }
    it { should == 21 }
  end

  describe "#version" do

    context "when not specified" do
      subject { QREncoder.encode(string).version }
      context "and string fits within version 1" do
        let(:string) { "hello" }
        it { should == 1 }
      end
      context "and string is too large for version 1" do
        let(:string) { "hello" }
        it { should == 1 }
      end
    end

    context "when specified" do
      subject { QREncoder.encode(string, :version => 2).version }
      context "and string fits within specified version" do
        let(:string) { "hello" }
        it { should == 2 }
      end
      context "and string is too large for specified version" do
        let(:string) { "Lorem ipsum dolor et al and then some more content" }
        it { should == 3 }
      end
    end

  end

  describe "#width" do
    subject { QREncoder.encode("test", :version => version).width }
    context "with version 1" do
      let(:version) { 1 }
      it { should == 21 }
    end
    context "with version 2" do
      let(:version) { 2 }
      it { should == 25 }
    end
    context "with version 3" do
      let(:version) { 3 }
      it { should == 29 }
    end
    context "with version 4" do
      let(:version) { 4 }
      it { should == 33 }
    end
    context "with version 5" do
      let(:version) { 5 }
      it { should == 37 }
    end
    context "with version 6" do
      let(:version) { 6 }
      it { should == 41 }
    end
    context "with version 11" do
      let(:version) { 11 }
      it { should == 61 }
    end
    context "with version 15" do
      let(:version) { 15 }
      it { should == 77 }
    end
    context "with version 40 (the maximum)" do
      let(:version) { 40 }
      it { should == 177 }
    end
  end

  describe "#height" do
    subject { QREncoder.encode("test") }
    it "should be the same as the width" do
      subject.height.should == subject.width
    end
  end

  describe "#pixels" do
    let(:qrcode) { QREncoder.encode("hi") }
    let(:pixels) do
      arr = []
      qrcode.data.each_slice(qrcode.width) do |a|
        arr << a.map { |p| p & 0x1 }
      end
      arr
    end

    it "provides pixel data" do
      qrcode.pixels.should == pixels
    end
  end

  describe "#points" do
    let(:qrcode) { QREncoder.encode("hi") }
    let(:points) do
      arr = []
      y = 0
      qrcode.data.each_slice(qrcode.width) do |r|
        x = 0;
        r.each do |p|
          if (p & 0x1) == 1
            arr << [x, y]
          end
          x += 1
        end
        y += 1
      end
      arr
    end

    it "provides point data" do
      qrcode.points.should == points
    end
  end

  describe "#canvas" do
    let(:qrcode) { QREncoder.encode("hi") }

    it "returns an instance of ChunkyPNG::Canvas" do
      qrcode.canvas.should be_kind_of(ChunkyPNG::Canvas)
    end

    context "with no options specified" do
      subject { qrcode.canvas }
      its(:width) { should == qrcode.width + (4 * 2) }
      specify "background should be white" do
        subject.get_pixel(1,1).should == ChunkyPNG::Color::WHITE
      end
    end

    context "with margin of 8" do
      subject { qrcode.canvas(:margin => 8) }
      its(:width) { should == qrcode.width + (8 * 2) }
    end

    context "with pixels-per-module of 2" do
      subject { qrcode.canvas(:pixels_per_module => 2) }
      its(:width) { should == (qrcode.width + 8) * 2 }
    end

    context "with transparent set to true" do
      subject { qrcode.canvas(:transparent => true) }
      specify "background should be transparent" do
        subject.get_pixel(1,1).should == ChunkyPNG::Color::TRANSPARENT
      end
    end
  end

  describe "#png" do
    let(:qrcode) { QREncoder.encode("hi") }

    it "returns an instance of QREncoder::PNG" do
      qrcode.png.should be_kind_of(QREncoder::PNG)
    end

    it "sends options to #canvas" do
      canvas = QREncoder::PNG.new(qrcode)
      options = { :margin => 5, :transparent => true }
      qrcode.should_receive(:png).with(options).and_return(canvas)
      qrcode.png(options)
    end
  end

  describe "#save_png" do
    let(:qrcode) { QREncoder.encode("hi") }
    let(:path) do
      File.expand_path("../../../tmp/test.png", __FILE__)
    end

    before { File.unlink(path) if File.file?(path) }

    it "saves a png image to path specified" do
      qrcode.save_png(path)
      File.open(path) { true }
      File.size(path).should_not be_zero
    end
  end

end
