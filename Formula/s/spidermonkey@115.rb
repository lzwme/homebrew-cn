class SpidermonkeyAT115 < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases115.17.0esrsourcefirefox-115.17.0esr.source.tar.xz"
  version "115.17.0"
  sha256 "80f184a102a743ee75401e86dd86af0be5f1e5ebf07c81119d9ca77422d716c3"
  license "MPL-2.0"
  revision 1

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:www.mozilla.orgen-USfirefoxreleases"
    regex(%r{href=.*?v?(115(?:\.\d+)+)releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3aebca08e0acc92e4ccc247686838664b7f392138f352d2911a4a56784233667"
    sha256 cellar: :any, arm64_sonoma:  "2138280c5b28d8ae8a5d020ec58dfafb4f5d37ee303510abccc1735529e64b90"
    sha256 cellar: :any, arm64_ventura: "592fa5ac198f1b18c0c00156d814495da628d23dde64fd7f377819822f9f88b3"
    sha256 cellar: :any, sonoma:        "ec5329a777657c76f8d2ccd1bdf93d1113d81b30d9f3d647a98252bcc23d481c"
    sha256 cellar: :any, ventura:       "b7a84a181eb2b6c5bd90afd99bad0af21957e94a03eb986504de601ad9440937"
    sha256               x86_64_linux:  "752a0b12ed649b4eaf208b3aeb1aeadaf6bb8775d9269eb8e4858159244fee2a"
  end

  disable! date: "2025-07-01", because: :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # https:bugzilla.mozilla.orgshow_bug.cgi?id=1857515
  depends_on "rust" => :build
  depends_on "icu4c@76"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  # From pythonmozbuildmozbuildtestconfiguretest_toolchain_configure.py
  fails_with :gcc do
    version "7"
    cause "Only GCC 8.1 or newer is supported"
  end

  # Apply patch used by `gjs` to bypass build error.
  # ERROR: *** The pkg-config script could not be found. Make sure it is
  # *** in your path, or set the PKG_CONFIG environment variable
  # *** to the full path to pkg-config.
  # Ref: https:bugzilla.mozilla.orgshow_bug.cgi?id=1783570
  # Ref: https:discourse.gnome.orgtgnome-45-to-depend-on-spidermonkey-11516653
  patch do
    on_macos do
      url "https:github.comptomatomozjscommit9f778cec201f87fd68dc98380ac1097b2ff371e4.patch?full_index=1"
      sha256 "a772f39e5370d263fd7e182effb1b2b990cae8c63783f5a6673f16737ff91573"
    end
  end

  def install
    # Workaround for ICU 76+
    # Issue ref: https:bugzilla.mozilla.orgshow_bug.cgi?id=1927380
    inreplace "jsmoz.configure", '"icu-i18n >= 73.1"', '"icu-i18n >= 73.1 icu-uc"'

    if OS.mac?
      inreplace "buildmoz.configuretoolchain.configure" do |s|
        # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
        s.sub! '"-Wl,--version"', '"-Wl,-ld_classic,--version"' if DevelopmentTools.clang_build_version >= 1500
        # Allow using brew libraries on macOS (not officially supported)
        s.sub!(^(\s*def no_system_lib_in_sysroot\(.*\n\s*if )bootstrapped and value:, "\\1False:")
        # Work around upstream only allowing build on limited macOS SDK (14.4 as of Spidermonkey 128)
        s.sub!(^(\s*def sdk_min_version\(.*\n\s*return )"\d+(\.\d+)*"$, "\\1\"#{MacOS.version}\"")
      end

      # Force build script to use Xcode install_name_tool
      ENV["INSTALL_NAME_TOOL"] = DevelopmentTools.locate("install_name_tool")
    end

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-hardening
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-shared-js
        --disable-bootstrap
        --disable-debug
        --disable-jemalloc
        --with-intl-api
        --with-system-icu
        --with-system-nspr
        --with-system-zlib
      ]

      system "..jssrcconfigure", *args
      system "make"
      system "make", "install"
    end

    rm(lib"libjs_static.ajs")

    # Avoid writing nspr's versioned Cellar path in js*-config
    inreplace bin"js#{version.major}-config",
              Formula["nspr"].prefix.realpath,
              Formula["nspr"].opt_prefix
  end

  test do
    path = testpath"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}js#{version.major} #{path}").strip
  end
end