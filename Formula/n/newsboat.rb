class Newsboat < Formula
  desc "RSSAtom feed reader for text terminals"
  homepage "https:newsboat.org"
  url "https:newsboat.orgreleases2.34newsboat-2.34.tar.xz"
  sha256 "73d7b539b0c906f6843a1542e1904a02ae430e79d6be4d6f9e2e2034eac2434e"
  license "MIT"
  head "https:github.comnewsboatnewsboat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f44eedb155e41dc3a5cd3720d5a737b1b04c6d73b9bed1552b85cb7051360a6d"
    sha256 arm64_ventura:  "92fa42ba9684b26e535453dd828a5a43cee64b7e066bab1d9dc348d130615ccb"
    sha256 arm64_monterey: "966ddaebb548f7fb0148c7e5db74e20c47ce2dedb81ee700641628154eb5f001"
    sha256 sonoma:         "fa32f1d63d746e5a9cd9654a12cb524f79244bd6562300b6108b27ba4d13e1bc"
    sha256 ventura:        "6b7210e257dc9308c1455bcae657b63a25a3b3dc93062e933cbe767a9f433eb1"
    sha256 monterey:       "cd4777df961b95a31210a7fabbddccfa1b7a77dc8de320367f46e267339b3702"
    sha256 x86_64_linux:   "84727fa839237468b974fe446ec692f56a37b284eff871b274c602c15a7a1283"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xz" => :build
  depends_on "gettext"
  depends_on "json-c"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "make" => :build
  end

  # Newsboat have their own libstfl fork. Upstream libsftl is gone:
  # https:github.comHomebrewhomebrew-corepull89981
  # They do not want to be the new upstream, but use that fork as a temporary
  # workaround until they migrate to some rust crate
  # https:github.comnewsboatnewsboatissues232
  resource("libstfl") do
    url "https:github.comnewsboatstfl.git",
        revision: "c2c10b8a50fef613c0aacdc5d06a0fa610bf79e9"
  end

  def install
    resource("libstfl").stage do
      if OS.mac?
        ENV.append "LDLIBS", "-liconv"
        ENV.append "LIBS", "-lncurses -lruby -liconv"

        inreplace "stfl_internals.h", "ncurseswncurses.h", "ncurses.h"
        inreplace %w[stfl.pc.in rubyMakefile.snippet], "ncursesw", "ncurses"

        inreplace "Makefile" do |s|
          s.gsub! "ncursesw", "ncurses"
          s.gsub! "-Wl,-soname,$(SONAME)", "-Wl"
          s.gsub! "libstfl.so.$(VERSION)", "libstfl.$(VERSION).dylib"
          s.gsub! "libstfl.so", "libstfl.dylib"
        end

        # Fix ncurses linkage for Perl bundle
        inreplace "perl5Makefile.PL", "-lncursesw", "-L#{MacOS.sdk_path}usrlib -lncurses"
      else
        ENV.append "LIBS", "-lncursesw -lruby"
        inreplace "Makefile", "$(LDLIBS) $^", "$^ $(LDLIBS)"
      end

      # Fix "call to undeclared function 'wget_wch'".
      ENV.append_to_cflags "-D_XOPEN_SOURCE_EXTENDED=1"

      # Fails race condition of test:
      #   ImportError: dynamic module does not define init function (init_stfl)
      #   make: *** [python_stfl.so] Error 1
      ENV.deparallelize do
        system "make"
        system "make", "install", "prefix=#{libexec}"
      end

      cp (libexec"liblibstfl.so"), (libexec"liblibstfl.so.0") if OS.linux?
    end

    gettext = Formula["gettext"]

    ENV["GETTEXT_BIN_DIR"] = gettext.opt_bin.to_s
    ENV["GETTEXT_LIB_DIR"] = gettext.lib.to_s
    ENV["GETTEXT_INCLUDE_DIR"] = gettext.include.to_s
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"

    # Remove once libsftl is not used anymore
    ENV.prepend_path "PKG_CONFIG_PATH", libexec"libpkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}lib"

    # Work around Apple's ncurses5.4-config outputting -lncursesw
    if OS.mac? && MacOS.version >= :sonoma
      system "gmake", "config", "prefix=#{prefix}"
      inreplace "config.mk", "-lncursesw", "-lncurses"
    end

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install", "prefix=#{prefix}"
  end

  test do
    (testpath"urls.txt").write "https:github.comblogsubscribe"
    assert_match "Newsboat - Exported Feeds", shell_output("LC_ALL=C #{bin}newsboat -e -u urls.txt")
  end
end