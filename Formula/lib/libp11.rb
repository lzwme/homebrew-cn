class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://ghfast.top/https://github.com/OpenSC/libp11/releases/download/libp11-0.4.17/libp11-0.4.17.tar.gz"
  sha256 "bbd86cdadd0493304be85c01a8604988c8f6c3fff8a902aa3f542a924699c080"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f29d8f49217c15b8a322b614e3c68884bbe9252350c8f6030776cf158fa696c"
    sha256 cellar: :any,                 arm64_sequoia: "20680029905d728ee5e0cc3b6a00ca88cf1b034a6b5bc33275e315739e4e9c42"
    sha256 cellar: :any,                 arm64_sonoma:  "ba2057c4b98095844a0728fce2b1f13f516f0d88f36a306d005cbf4a856b9be6"
    sha256 cellar: :any,                 sonoma:        "ee0162528d5473f8c89ade8e0b2cca71a15152d8c5a376a76d0a3840f1c2c298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f984f63a85077100d1865174163319bc835e3f813e9cdcd979abc6a98dcc97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e038457691894c929a0f468744f27f14379152de24c415af76edf7a5e15933e"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkgconf", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    modulesdir = Utils.safe_popen_read("pkgconf", "--variable=modulesdir", "libcrypto").chomp
    modulesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}",
                          "--with-modulesdir=#{modulesdir}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end