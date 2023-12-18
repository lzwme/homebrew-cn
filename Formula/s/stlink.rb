class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https:github.comstlink-orgstlink"
  url "https:github.comstlink-orgstlinkarchiverefstagsv1.7.0.tar.gz"
  sha256 "57ec1214905aedf59bee7f70ddff02316f64fa9ba5a9b6a3a64952edc5b65855"
  license "BSD-3-Clause"
  head "https:github.comstlink-orgstlink.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0fbf4050373180e7d9510579c77d836b48033b9b06e89a34156b777b38e5dd58"
    sha256 cellar: :any,                 arm64_ventura:  "37bc6182a2709fbcd5046be4c1cb93936475f12d2ee42983e9f7802ed89bc97c"
    sha256 cellar: :any,                 arm64_monterey: "2ea4763e208c5566d0ec1848a6d91c440fe745287aa7a5617af635fea7707af0"
    sha256 cellar: :any,                 arm64_big_sur:  "79683924dac821a1744cf32a96c3296eecd1668b5f2f64dbdcf570f32480459f"
    sha256 cellar: :any,                 sonoma:         "53e58898f8926563bbf42ea5eb8cb9611a5f1afe937b9daefa54b53e3bc0a5b9"
    sha256 cellar: :any,                 ventura:        "4aff6679ab6726e3d7a397a17de9de8972d233971907811f2113c94a4a7c7560"
    sha256 cellar: :any,                 monterey:       "32411be4437ac85b5b9feb0fc38306af2dfc1f895ad4661c2187eb70a8420b0f"
    sha256 cellar: :any,                 big_sur:        "9ea7be4ae1c0b91ceeb40c6df9d07ad6a5660be80043895bcf29acc47988d10d"
    sha256 cellar: :any,                 catalina:       "e162fb37d4a7e2a0e006c5cb9beae3b86784d6a0b3d371fc33d7ed9ba2140083"
    sha256 cellar: :any,                 mojave:         "f112f45203b8c460da03ae840529d4564a677d0621ac0a9576bac510258a9ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "141e0873ed4745b1224f6996f5dac5461f27a87e17d36a9f56a080f27a922f23"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    libusb = Formula["libusb"]
    args << "-DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}libusb-#{libusb.version.major_minor}"
    args << "-DLIBUSB_LIBRARY=#{libusb.opt_libshared_library("libusb-#{libusb.version.major_minor}")}"

    if OS.linux?
      args << "-DSTLINK_MODPROBED_DIR=#{lib}modprobe.d"
      args << "-DSTLINK_UDEV_RULES_DIR=#{lib}udevrules.d"
    end
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match "st-flash #{version}", shell_output("#{bin}st-flash --debug reset 2>&1", 255)
  end
end