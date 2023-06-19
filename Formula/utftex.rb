class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://ghproxy.com/https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.23.tar.gz"
  sha256 "44f4ca8bf2aaaa6a904b10ed4b9c0f86d20d10463e3b38c99fa63a81cb16ebf5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93eafbbda6a3c491ab3780bb62330c31b8bc09aa22534a135c4b6704ead9d42d"
    sha256 cellar: :any,                 arm64_monterey: "5da4863b8c217392263fe348363a381f519cbf4e1888badb7781b355f9a18f11"
    sha256 cellar: :any,                 arm64_big_sur:  "1f475a9e1a0bfe19cc67f554d9dc5b885bc9939df34f7d6d418798132c74e3f1"
    sha256 cellar: :any,                 ventura:        "daa4951a0bef28e9a51ef1c0b66371897f24f7ca43ddc1a99d94dcf618b078ce"
    sha256 cellar: :any,                 monterey:       "9540eda09ed33d774271a8ce9748798dc16a9dc007aba17f2a80a9914a59c4b0"
    sha256 cellar: :any,                 big_sur:        "e224fee5506f4cd8a5058ce072a10ce473183573f1454398c7edd85bd6fd8bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f1b00a1d3a04fb2d775a0d8fc0df51e2013629b9d36eac06c0403a612470f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end