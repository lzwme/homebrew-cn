class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https:pagure.ionewt"
  url "https:releases.pagure.orgnewtnewt-0.52.24.tar.gz"
  sha256 "5ded7e221f85f642521c49b1826c8de19845aa372baf5d630a51774b544fbdbb"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https:releases.pagure.orgnewt"
    regex(href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6fef0c730e2f3d0b515f083aea35a4ae49392f3569ef1aca6504844affc383c4"
    sha256 cellar: :any,                 arm64_ventura:  "fd94edbcdf0629ef5fb24db2703123de900979f369e9e25b7bda03fc5d033859"
    sha256 cellar: :any,                 arm64_monterey: "22eb2fad05aa6aff24b2b7505104b5c4271ad70a8df926f251af9a9c593c0d30"
    sha256 cellar: :any,                 sonoma:         "819cb00422244756274b585a0bccf7f54762370a0ea648965ef39138d3a685de"
    sha256 cellar: :any,                 ventura:        "b3f5fcd756f1dd4f14b1567119a6ce0541a6c443d8ee7b96b7c64464b730712d"
    sha256 cellar: :any,                 monterey:       "a20db7d51b6ef173321eecb82d77d665b6a8b0854c33eb4a5cc7da2b00edc73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf13c11b78ec2b669d9097139a3248d019f5f614f34d463fae6cfb3dd64eb98"
  end

  depends_on "popt"
  depends_on "python@3.11"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.11"
  end

  def install
    if OS.mac?
      inreplace "Makefile.in" do |s|
        # name libraries correctly
        # https:bugzilla.redhat.comshow_bug.cgi?id=1192285
        s.gsub! "libnewt.$(SOEXT).$(SONAME)", "libnewt.$(SONAME).dylib"
        s.gsub! "libnewt.$(SOEXT).$(VERSION)", "libnewt.$(VERSION).dylib"

        # don't link to libpython.dylib
        # causes https:github.comHomebrewhomebrewissues30252
        # https:bugzilla.redhat.comshow_bug.cgi?id=1192286
        s.gsub! "`$$pyconfig --ldflags`", '"-undefined dynamic_lookup"'
        s.gsub! "`$$pyconfig --libs`", '""'
      end
    end

    system ".configure", "--prefix=#{prefix}", "--without-tcl", "--with-python=#{python3}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system python3, "-c", "import snack"

    (testpath"test.c").write <<~EOS
      #import <newt.h>
      int main() {
        newtInit();
        newtFinished();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnewt"
    system ".test"
  end
end