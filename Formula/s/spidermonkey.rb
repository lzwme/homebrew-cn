class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases128.4.0esrsourcefirefox-128.4.0esr.source.tar.xz"
  version "128.4.0"
  sha256 "074014e1c26144e10707b12a271176a4b6b67021e91444b613edae38d188febc"
  license "MPL-2.0"
  revision 1
  head "https:hg.mozilla.orgmozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:download.mozilla.org?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "61b7051e96d04b5b6ddacc8ee0800b243b4ea2453bd795c07980958f93f4d174"
    sha256 cellar: :any, arm64_sonoma:  "88ab4784c34102c8fb93c8915cdcbd1ac7496460ffe84b5a30bea713d29be343"
    sha256 cellar: :any, arm64_ventura: "ec7e958ab256a5962f4ba60c12b368dc8609d0f156ddf23657bb54612db09287"
    sha256 cellar: :any, sonoma:        "88c0d75a9e74c2979b9e7afe93d4e615032508fa92c4ebd3b0ca26e2436b9f69"
    sha256 cellar: :any, ventura:       "be20966c58859beea2f86f730aed999e4adb9222a2ff4350b94952e0adcd8c0e"
    sha256               x86_64_linux:  "d0664eeb42fb30dceab87318b21513762cc47dda62a91b21e1870421fc08ad81"
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

  conflicts_with "narwhal", because: "both install a js binary"

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