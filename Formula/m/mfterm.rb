class Mfterm < Formula
  desc "Terminal for working with Mifare Classic 1-4k Tags"
  homepage "https://github.com/4ZM/mfterm"
  url "https://ghproxy.com/https://github.com/4ZM/mfterm/releases/download/v1.0.7/mfterm-1.0.7.tar.gz"
  sha256 "b6bb74a7ec1f12314dee42973eb5f458055b66b1b41316ae0c5380292b86b248"
  license "GPL-3.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d6700be1830322a6b2c164cecdfcdbeb2285c4ab2db1518a0782f820e842b63b"
    sha256 cellar: :any,                 arm64_monterey: "a8910ab8b9320d26fb258e95f1d2d8a1d5d8dfcbed739464c916e6f0b6b8b896"
    sha256 cellar: :any,                 arm64_big_sur:  "d8ebffdc37a5ab667c1e7c969d66bf2407c820ade96701806fc149f8e95ffe78"
    sha256 cellar: :any,                 ventura:        "bf979c85bd74aef426a7d1911fb54ec6e9d3e187c2fba1b692dc502020b832cc"
    sha256 cellar: :any,                 monterey:       "524e0778d1d15de19bbb7e5f052c338542f2fd4684f4f1cae018cf662bbb1f81"
    sha256 cellar: :any,                 big_sur:        "4f1976bef27bb44358dfb064726b666b3b7e08a7e2670d0964423fa78b8afa1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f878e049935d495a6621ac26fb0757f6a936c4e85fa2f6ba1058feb4e7d844"
  end

  head do
    url "https://github.com/4ZM/mfterm.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libnfc"
  depends_on "libusb"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib}"

    if build.head?
      chmod 0755, "./autogen.sh"
      system "./autogen.sh"
    end
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/mfterm", "--version"
  end
end