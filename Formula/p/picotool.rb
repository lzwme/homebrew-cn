class Picotool < Formula
  desc "Tool for interacting with RP2040RP2350 devices and binaries"
  homepage "https:github.comraspberrypipicotool"
  license "BSD-3-Clause"

  stable do
    url "https:github.comraspberrypipicotoolarchiverefstags2.0.0.tar.gz"
    sha256 "9392c4a31f16b80b70f861c37a029701d3212e212840daa097c8a3720282ce65"

    resource "pico-sdk" do
      url "https:github.comraspberrypipico-sdkarchiverefstags2.0.0.tar.gz"
      sha256 "626db87779fa37f7f9c7cfe3e152f7e828fe19c486730af2e7c80836b6b57e1d"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "d2cdf2d3bef83207f173ee96fcb66976fe14b638fa2b941e6f16f44ab60bfc93"
    sha256 arm64_ventura:  "91dce37d751e159802bbccd9d11be16f8620197f04240c612efa6ba8bb09a393"
    sha256 arm64_monterey: "e4bf549b3d172a4f93e1f965df6d004550ff4322a40118a1caf18774d729c297"
    sha256 sonoma:         "8534519fb9e80d196690f5b4a27880533847dce3d1e3b2103d7c66565bf826f7"
    sha256 ventura:        "56c36f61d6f798a875a6db5744e8fb4ad9936dc3f57c334ed46224fc9728b3d7"
    sha256 monterey:       "19af651cbee2f74c3808681cf1afba755e849f39d01750cbe15e0a754486ae5d"
    sha256 x86_64_linux:   "e92224ae304cef3422d9abb25f79316f895a26cfcfe8a7677c25266fc54e1eaf"
  end

  head do
    url "https:github.comraspberrypipicotool.git", branch: "master"

    resource "pico-sdk" do
      url "https:github.comraspberrypipico-sdk.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  resource "homebrew-pico-blink" do
    url "https:rptl.iopico-blink"
    sha256 "4b2161340110e939b579073cfeac1c6684b35b00995933529dd61620abf26d6f"
  end

  def install
    resource("pico-sdk").stage buildpath"pico-sdk"

    args = %W[-DPICO_SDK_PATH=#{buildpath}pico-sdk]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-pico-blink").stage do
      result = <<~EOS
        File blink.uf2:

        Program Information
         name:          blink
         web site:      https:github.comraspberrypipico-examplestreeHEADblink
         binary start:  0x10000000
         binary end:    0x10003198
      EOS
      assert_equal result, shell_output("#{bin}picotool info blink.uf2")
    end
  end
end