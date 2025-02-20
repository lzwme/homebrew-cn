class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https:github.commerbananrtl_433"
  url "https:github.commerbananrtl_433archiverefstags25.02.tar.gz"
  sha256 "5a409ea10e6d3d7d4aa5ea91d2d6cc92ebb2d730eb229c7b37ade65458223432"
  license "GPL-2.0-or-later"
  head "https:github.commerbananrtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cadc9ac43692b5342a8d9fd305bf36598ce8e8f9cbcf088f3b87e7117f569f4c"
    sha256 cellar: :any,                 arm64_sonoma:  "6e8b6406520ac6b02a6d5292ed085c377edc6214dd817e27850a91d1216883b0"
    sha256 cellar: :any,                 arm64_ventura: "ed54be9e72784603e4e6b1b7b1ae679f15ab03cf1ee92efa7c36151b40b81274"
    sha256 cellar: :any,                 sonoma:        "9ba535a042f8ea9bb058ae0b78ed860f4a3157ff228b68c2b5dbe7bd9eea8d2e"
    sha256 cellar: :any,                 ventura:       "e5165eebfca6801f1c588fac131f5b054d37974adc912fc6aead1286e60629f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb83d5f1303cc5aa8dd4d79d7609f0fc9c2ec1d530584a7c7e6648fdd4d0a42"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_cu8" do
      url "https:raw.githubusercontent.commerbananrtl_433_testsmastertestsoregon_scientificuvr128g001_433.92M_250k.cu8"
      sha256 "7aa07b72cec9926f463410cda6056eb2411ac9e76006ba4917a0527492c5f65d"
    end

    resource "homebrew-expected_json" do
      url "https:raw.githubusercontent.commerbananrtl_433_testsmastertestsoregon_scientificuvr128g001_433.92M_250k.json"
      sha256 "5054c0f322030dd1ee3ca78261b64e691da832900a2c6e4d13cc22f0fbbfbbfa"
    end

    testpath.install resource("homebrew-test_cu8")
    testpath.install resource("homebrew-expected_json")

    expected_output = (testpath"g001_433.92M_250k.json").read
    rtl_433_output = shell_output("#{bin}rtl_433 -c 0 -F json -r #{testpath}g001_433.92M_250k.cu8")

    assert_equal rtl_433_output, expected_output
  end
end