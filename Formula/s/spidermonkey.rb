class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases128.7.0esrsourcefirefox-128.7.0esr.source.tar.xz"
  version "128.7.0"
  sha256 "e0a7bf4eddfa33cbc8797d68ecea8fb4e6404ca197d3b2242cbc8daed03794f7"
  license "MPL-2.0"
  head "https:hg.mozilla.orgmozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:download.mozilla.org?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "87c699d9331e223c485ac64795c43c3495b359cec431d2f9c94499f73cc67761"
    sha256 cellar: :any, arm64_sonoma:  "4a0e35f532e855103703602ee8ad19a58ac023da175587ed2bf4582eb16fcd42"
    sha256 cellar: :any, arm64_ventura: "756b9562dfdfe1c5f0428fc89cc9cb55bd652b053b2575e9b7667db97748226e"
    sha256 cellar: :any, sonoma:        "bc72ec9d8810c132861d4159bd59af740dcd84c216892a01688201d78d855a62"
    sha256 cellar: :any, ventura:       "d38acf1650334e54c9399871c66a0998da05b50535fe5905a0450e5d3e2d9a50"
    sha256               x86_64_linux:  "5400ba52fb2299ddd49cbe3ed52dcbbce7a3d0b94ff9a023b8e71abaf1cc5ab9"
  end

  depends_on "cbindgen" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
      url "https:github.comptomatomozjscommitc82346c4e19a73ed4c7f65a6b274fc2138815ae9.patch?full_index=1"
      sha256 "0f1cd5f80b4ae46e614efa74a409133e8a69fff38220314f881383ba0adb0f87"
    end
  end

  def install
    # Workaround for ICU 76+
    # Issue ref: https:bugzilla.mozilla.orgshow_bug.cgi?id=1927380
    inreplace "jsmoz.configure", '"icu-i18n >= 73.1"', '"icu-i18n >= 73.1 icu-uc"'

    ENV.runtime_cpu_detection

    if OS.mac?
      inreplace "buildmoz.configuretoolchain.configure" do |s|
        # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
        s.sub! '"-Wl,--version"', '"-Wl,-ld_classic,--version"' if DevelopmentTools.clang_build_version >= 1500
        # Allow using brew libraries on macOS (not officially supported)
        s.sub!(^(\s*def no_system_lib_in_sysroot\(.*\n\s*if )bootstrapped and value:, "\\1False:")
        # Work around upstream only allowing build on limited macOS SDK (14.4 as of Spidermonkey 128)
        s.sub!(^(\s*def mac_sdk_min_version\(.*\n\s*return )"\d+(\.\d+)*"$, "\\1\"#{MacOS.version}\"")
      end
    end

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-hardening
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-rust-simd
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
      ENV.deparallelize { system "make" }
      system "make", "install"
    end

    rm(lib"libjs_static.ajs")

    # Add an unversioned `js` to be used by dependents like `jsawk` & `plowshare`
    bin.install_symlink "js#{version.major}" => "js"

    # Avoid writing nspr's versioned Cellar path in js*-config
    inreplace bin"js#{version.major}-config",
              Formula["nspr"].prefix.realpath,
              Formula["nspr"].opt_prefix
  end

  test do
    path = testpath"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}js#{version.major} #{path}").strip
    assert_equal "hello", shell_output("#{bin}js #{path}").strip
  end
end