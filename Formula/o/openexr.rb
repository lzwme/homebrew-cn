class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d7b31637d7adc359f5e5a7517ba918cb5997bc1a4ae7a808ec874cdf91da93c0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ade6e4cd035310443eb46105b4c83aa365815c91377bf696a0685393d6de755"
    sha256 cellar: :any,                 arm64_sonoma:  "0bc589d05bb2b9f210473cf8d56ed83ef0dc7b2764a8a461bc2afc8803d2622e"
    sha256 cellar: :any,                 arm64_ventura: "9ee980357bf552516799bcb6c7ca3a0deb6922337a8d99846b5edef95c62e937"
    sha256 cellar: :any,                 sonoma:        "334fcb1af5ddc4888fb2d1a02b66141634597c0b9ce5a358d38af6b3be1a6d4f"
    sha256 cellar: :any,                 ventura:       "78ce6f31f674d776a9f34f08ce9dda578b5698037b8c12252d97b5d2859ae692"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aacf9c9c68dae9fe9d5b7961ec2716847f581363d74760c4d1a8259020613e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99095f437c595ad947a9d78b869d9ef2940ed03b1465a763b886225e677d405e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end