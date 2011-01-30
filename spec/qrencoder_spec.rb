require 'spec_helper'

describe QREncoder do

  describe ".encode" do
    context "when passed a string" do
      subject { QREncoder.encode("string") }

      it { should be_a_kind_of(QREncoder::QRCode) }
    end

    context "when passed a string and version option" do
      subject { QREncoder.encode("string", :version => 2) }

      it { should be_a_kind_of(QREncoder::QRCode) }
      it "encodes using the specified version" do
        QREncoder::QRCode.should_receive(:new).with("string",
                                                                 2,
                                                                 QREncoder::QR_ECLEVEL_L,
                                                                 QREncoder::QR_MODE_8,
                                                                 1)
        subject
      end
    end

    context "when passed a string and correction option" do
      subject { QREncoder.encode("string", :correction => :high) }

      it { should be_a_kind_of(QREncoder::QRCode) }
      it "encodes using the specified correction mode" do
        QREncoder::QRCode.should_receive(:new).with("string",
                                                                 1,
                                                                 QREncoder::QR_ECLEVEL_H,
                                                                 QREncoder::QR_MODE_8,
                                                                 1)
        subject
      end
    end

    context "when passed a string and mode option" do
      subject { QREncoder.encode("string", :mode => :alphanumeric) }

      it { should be_a_kind_of(QREncoder::QRCode) }
      it "encodes using the specified correction mode" do
        QREncoder::QRCode.should_receive(:new).with("string",
                                                                 1,
                                                                 QREncoder::QR_ECLEVEL_L,
                                                                 QREncoder::QR_MODE_AN,
                                                                 1)
        subject
      end
    end

    context "when passed a string and case_sensitive option" do
      subject { QREncoder.encode("string", :case_sensitive => false) }

      it { should be_a_kind_of(QREncoder::QRCode) }
      it "encodes using the specified correction mode" do
        QREncoder::QRCode.should_receive(:new).with("string",
                                                                 1,
                                                                 QREncoder::QR_ECLEVEL_L,
                                                                 QREncoder::QR_MODE_8,
                                                                 0)
        subject
      end
    end
  end

end
