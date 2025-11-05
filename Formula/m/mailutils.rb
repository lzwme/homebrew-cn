class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftpmirror.gnu.org/gnu/mailutils/mailutils-3.20.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.20.tar.gz"
  sha256 "d10ee65ba391d6463952d8a81551f8a6e667538ee8587b3c801137e657087d4c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "cdba3d1331e33e64f389b2795c7dc3c9b959d0595d9077950e35a61c867e0db2"
    sha256 arm64_sequoia: "08b55cfd3926a5fd45693591c7ac4c0da39149fa8c28fbcfae097848eda659c2"
    sha256 arm64_sonoma:  "f1c0211a199b18c353026162e6c3cfea238458f5fc4eac45f976f19e7a3f0f91"
    sha256 sonoma:        "5b7387ebdf85f25c6acccd1cec3691a971c05755efb56eff8a98830475947e5d"
    sha256 arm64_linux:   "86fb0ff32496469f2376f994228719e6ad518b4e2e01ad05903bd94dd2b880f2"
    sha256 x86_64_linux:  "5e4b9084e16b4cd161693e803c657a9c19ea6f145b1d9a2f4cda323a5429b8ac"
  end

  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "python"

  on_macos do
    depends_on "gettext"
  end

  def install
    # This is hardcoded to be owned by `root`, but we have no privileges on installation.
    inreplace buildpath.glob("dotlock/Makefile.*") do |s|
      s.gsub! "chown root:mail", "true"
      s.gsub! "chmod 2755", "chmod 755"
    end

    system "./configure", "--disable-mh",
                          "--disable-silent-rules",
                          "--without-fribidi",
                          "--without-guile",
                          "--without-tokyocabinet",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"movemail", "--version"
  end
end