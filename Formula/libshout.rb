class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.6.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  sha256 "39cbd4f0efdfddc9755d88217e47f8f2d7108fa767f9d58a2ba26a16d8f7c910"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/?C=M&O=D"
    regex(/href=.*?libshout[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9231d4d7890507d132e7a64201b7ead203a22cb47850c9cf7ee099fbc5c8a6cd"
    sha256 cellar: :any,                 arm64_monterey: "60b072983a4133b4e504760df1173592f72f20ad4c563eaf4818c3f1de726c04"
    sha256 cellar: :any,                 arm64_big_sur:  "5556dc649d2ffc26db4982b4454fa398bbbe984dcdabcc43463c1ef9af7a01f0"
    sha256 cellar: :any,                 ventura:        "89f4593d901019c32468604a871a46524d30b48a9dbd09a060e00e99e487a99a"
    sha256 cellar: :any,                 monterey:       "8ab0df70741deb6cec78b95f37fb60ff5504a3f077033c2b4c7ae76745d8987f"
    sha256 cellar: :any,                 big_sur:        "97acacadd869bf35f1a8ae8fb4c5771a028d531272313b5dbc55348ce197ebd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898c7da67e779f3cce1a4b3f7b5cff8af87725d7235b3a138c06396db1b2eeec"
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openssl@3"
  depends_on "speex"
  depends_on "theora"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version == 1403
    system "./configure", *std_configure_args
    system "make", "install"
  end
end