class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https:github.comopenzimlibzim"
  url "https:github.comopenzimlibzimarchiverefstags9.2.3.tar.gz"
  sha256 "7c6e7fcaf5bc82447edb12c6c573779af6d77b3b79227da57586e81c4e13f1bf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "679cd93009e9c5e0f0ae21ddc4b39487cf6beb02417e720b6e837f77d56b1331"
    sha256 cellar: :any, arm64_sonoma:   "7568b83f08fc94270166a38329dfddce78683ec39f95fadbe58e435c07ced45e"
    sha256 cellar: :any, arm64_ventura:  "37b642fca20f63876f6680c50f572c8b6174f35f40431c82a37c7f6de3bca1af"
    sha256 cellar: :any, arm64_monterey: "2ef8b0cdc82668c43535df80f76baeb012c130fab6883f83e9eb0eaeca486200"
    sha256 cellar: :any, sonoma:         "19018c8f6d7aeb22a6ef3087644fdb063efbf7479f03b37563b9fa01f4362f0b"
    sha256 cellar: :any, ventura:        "a818dc7a2119af90bd80e0e74be039da19c4e8b1009bdf0762652ee659455fb1"
    sha256 cellar: :any, monterey:       "a6207d366c82707f233e0bd6edc7c4b295a24fd9cca8d679868159dcb47eecb0"
    sha256               x86_64_linux:   "c6fa0ec03e44ffed7d5d83d8c97ecbcfa41b6306dcda0f41c2b86920eb4ce45e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <zimversion.h>
      int main(void) {
        zim::printVersions();  first line should print "libzim <version>"
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"

    # Assert the first line of output contains "libzim <version>"
    assert_match "libzim #{version}", shell_output(".test")
  end
end