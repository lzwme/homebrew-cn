class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://ghfast.top/https://github.com/Hamlib/Hamlib/releases/download/4.6.4/hamlib-4.6.4.tar.gz"
  sha256 "5a92e93e805b2263c63da40028d67580fda15752b5389c68b237203f29b592bb"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d8126e5495497a041a558e7c393b47705dcad4b7ef37f26e4606f65e6978078"
    sha256 cellar: :any,                 arm64_sonoma:  "59954b13787f521f1007700ecffc8054996dc710e22e5a8321b000256832e1e1"
    sha256 cellar: :any,                 arm64_ventura: "3055a30abd235620700518087715fea409455ac2cc989fe908f5c7efd5aaac8e"
    sha256 cellar: :any,                 sonoma:        "498e9d0c6b6ff5213ef58752564808f8b9643fe4a5092a3bd9d6651b11db1493"
    sha256 cellar: :any,                 ventura:       "e1ef0c7b658186fa37c6dee7f5187a0dba521ccbc36e8dd8dc53f4a194452915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe723ccb2e829526bd13edf8428ca8974a392e81e86a3c07c26ede83a9839b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64f85b19eb149fc827b6695ad15b020b48825b44c9341349babc357fe582c1d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rigctl", "-V"
  end
end