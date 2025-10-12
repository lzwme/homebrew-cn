class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.42.tar.gz"
  sha256 "fbd7d1b04efee62c8241255a3fe1c5f5236f1a6e1ed85f02730b0c6448810175"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "46227beea4dc1f77c8afc4218943ba29c96867f722d642c25b972b5a0ebba294"
    sha256 arm64_sequoia: "de779407ea99469d59b3a2297d71d80e0ded3e9ae7f8d044c004f4636d93512b"
    sha256 arm64_sonoma:  "defe114e3babb6708e8fb9ba74a8f4a35ce23c964d67a66892c96afae41b13f4"
    sha256 sonoma:        "61695dc0215026f48a8984de2f4a69d04e08bac51a83f46dfb3b764723ef9a21"
    sha256 arm64_linux:   "cb8af77ceb6ed380460aee0000bc58452b46a1383a982debbcba0e19656e098b"
    sha256 x86_64_linux:  "c26a3ab93e46e65b876005491627e84f40f71251daa104440b6dbab9d0615cc4"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end