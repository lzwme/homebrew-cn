class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https:pagure.ionewt"
  url "https:releases.pagure.orgnewtnewt-0.52.25.tar.gz"
  sha256 "ef0ca9ee27850d1a5c863bb7ff9aa08096c9ed312ece9087b30f3a426828de82"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https:releases.pagure.orgnewt"
    regex(href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55c3fff9cb1b7ecc4d79bf8d424722951ae868232a23e0d052f1075b48f8bd90"
    sha256 cellar: :any,                 arm64_sonoma:  "2ba4e9d33882026f010c930fbc36e47158e1ef840a5a4fff21543a9a8c3199ff"
    sha256 cellar: :any,                 arm64_ventura: "9b26e7c2f6783d465fb10251fe5ace9ca123935fd8d62405b0cdafc09b239421"
    sha256 cellar: :any,                 sonoma:        "0070ed88421803c94c0e9dc89b28893de88485c3d96d044a52371f1d3f1973f2"
    sha256 cellar: :any,                 ventura:       "2e7bed21a287498a91d39efa5a5efc0ef17fd5f521640d761510118a8be03876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5fc54cd40c63896f983126433758a86bc3435c39188ae3c3e45569759f2170"
  end

  depends_on "popt"
  depends_on "python@3.13"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.13"
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
        s.gsub! "`$$pyconfig --ldflags --embed || $$pyconfig --ldflags`", '"-undefined dynamic_lookup"'

        s.gsub! "`$$ver -c \"import sysconfig; print(sysconfig.get_path('platlib'))\"`",
                "#{lib}python3.13site-packages"
      end
    end

    system ".configure", "--prefix=#{prefix}", "--without-tcl", "--with-python=#{python3}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system python3, "-c", "import snack"

    (testpath"test.c").write <<~C
      #import <newt.h>
      int main() {
        newtInit();
        newtFinished();
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnewt"
    system ".test"
  end
end