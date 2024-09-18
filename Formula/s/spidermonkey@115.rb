class SpidermonkeyAT115 < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases115.15.0esrsourcefirefox-115.15.0esr.source.tar.xz"
  version "115.15.0"
  sha256 "effed92aa0d961871614c611259dfe3eab72e5ebfe8f2405f9bc92c5e7feae81"
  license "MPL-2.0"

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:www.mozilla.orgen-USfirefoxreleases"
    regex(%r{href=.*?v?(115(?:\.\d+)+)releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "4e03384ada53f4a9cb2ca7dc2516ebfde84d687c218f1f76440e9814b7720314"
    sha256 cellar: :any, arm64_sonoma:   "c909bdf0a237d1062f9cccbece97b90f5e2dad5c158d673ce1ce781eb6de0025"
    sha256 cellar: :any, arm64_ventura:  "a1c77c4eef8c3b150776bb685ce88b6e321e29d633dc7841ac87d37475126293"
    sha256 cellar: :any, arm64_monterey: "8e5ee05481498bc8ab38563e732b44b9550310d7a655c7e29721ad9121d7db8e"
    sha256 cellar: :any, sonoma:         "f1394a2ed08e02c10e2d90a90eb823efb4df8ac23056bf51b91a7f279c1326a0"
    sha256 cellar: :any, ventura:        "0c4664ce308ec06930173d8eb89bfc9ae9d0e08fab9a78d119b50b0baa1e032b"
    sha256 cellar: :any, monterey:       "36ca91e39296f273d1d04433d94b6d7f569b291ca968eef81ee3a01049ed1a8c"
    sha256               x86_64_linux:   "dfb514aca444b386ee25593865c7cb90a88fa811aa3e3e186d0fe30aa218ba69"
  end

  disable! date: "2025-07-01", because: :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # https:bugzilla.mozilla.orgshow_bug.cgi?id=1857515
  depends_on "rust" => :build
  depends_on "icu4c"
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