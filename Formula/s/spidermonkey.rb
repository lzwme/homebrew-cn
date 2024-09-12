class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases128.2.0esrsourcefirefox-128.2.0esr.source.tar.xz"
  version "128.2.0"
  sha256 "9617a1e547d373fe25c2f5477ba1b2fc482b642dc54adf28d815fc36ed72d0c2"
  license "MPL-2.0"
  head "https:hg.mozilla.orgmozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:www.mozilla.orgen-USfirefoxorganizationsnotes"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "a48639001f6f9ed05f6e4ebc1019c90973ca2527761e82a2bd4dc4d5e46032c5"
    sha256 cellar: :any, arm64_sonoma:   "cbea1e2cff3267795eeac7b12c1033c2e1159bcf0fb2aaba19db5df928419e18"
    sha256 cellar: :any, arm64_ventura:  "364079dc6acbed8160fda49345ce9028fc9f1b1d3a536bdfd14913f5693db4d4"
    sha256 cellar: :any, arm64_monterey: "e63fd223d1d8b83fe4082a0b0bd194376a625559b7d5c74cef621f7953ae1a07"
    sha256 cellar: :any, sonoma:         "3e023d4431f7d23e72db93475d90a7e557c9a384d441978caa4fb00f1375189d"
    sha256 cellar: :any, ventura:        "d0ca7fb0c5eb46034d8071c688335aa3e160c3eae6573ef3f849669c5bb54257"
    sha256 cellar: :any, monterey:       "047654f00524d97eb78fc4e3a468f04c05246a0b6cdda4ba635a4fb3692c98ca"
    sha256               x86_64_linux:   "a0a206d3d430733f9567c7b435e719bb4f3a3708b3f096391624f1d3fa69fc1a"
  end

  depends_on "cbindgen" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build
  depends_on "icu4c"
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