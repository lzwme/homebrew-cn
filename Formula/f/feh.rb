class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.11.tar.bz2"
  sha256 "e35597564fd7ad6106127fbbf2f2bb92ea264e75b0fcbffc054db43c933dbd2a"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3edc0ff9db1e13bd29fa5144cbbc6b332dabdce64a352cadc65834d9a4fc31ac"
    sha256 arm64_sonoma:  "d92e28ddc0e870ab02c2152f90fe9f31d4e7673ac44e5ddfb747ca7c89052c00"
    sha256 arm64_ventura: "fd97de74b615d4fdce84fb558532dbb6c885482919a5306cdfa23d1c6f4484a6"
    sha256 sonoma:        "e5fa987a268195abda42635655fcdf00ee971cee03c801723ddcfb757944bd4f"
    sha256 ventura:       "c02b04d3db2af325f162fa3fd466189aaf82cb2a72b4fd4447fe79efd05af203"
    sha256 arm64_linux:   "a6640329ee761493e4fe23c1cb864f901a967af6261151f84851ac1b67175f1b"
    sha256 x86_64_linux:  "3b7521ea88467497ea4f6bb04986f1f1f43cb18919af632c6a3d1959bcad088f"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end