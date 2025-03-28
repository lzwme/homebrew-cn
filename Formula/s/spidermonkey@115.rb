class SpidermonkeyAT115 < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases115.21.1esrsourcefirefox-115.21.1esr.source.tar.xz"
  version "115.21.1"
  sha256 "470d5e5a6c27df2d91a69d885951a79b807b5586e4ad88c76e6c1764007e696a"
  license "MPL-2.0"

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:www.mozilla.orgen-USfirefoxreleases"
    regex(%r{href=.*?v?(115(?:\.\d+)+)releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a42077f39379699a473adb4e79164d92c0f6c4c20db07b3a4732035fe224d0b9"
    sha256 cellar: :any, arm64_sonoma:  "8fc473556b2f5adf5420db80ce871fdd3afc557b3ee3fbdb8cff27643ccd3e79"
    sha256 cellar: :any, arm64_ventura: "9d5b44b87e378f8e4b78358914be10e691921f32a93d110ccf81d4e5dce66d92"
    sha256 cellar: :any, sonoma:        "8c027addceb53ae0757838c2ff7b558a60766055948f5f5ce18a7b994f877979"
    sha256 cellar: :any, ventura:       "8287c96b8d3461d5118dcefb0e3e9f4e2de5e7934b87aa8425ac97a3f302f530"
    sha256               x86_64_linux:  "5cffaa54797b887447ef64e0eb413307491060b7ca6354c38087446e6eb94757"
  end

  disable! date: "2025-07-01", because: :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "python@3.11" => :build # https:bugzilla.mozilla.orgshow_bug.cgi?id=1857515
  depends_on "rust" => :build
  depends_on "icu4c@77"
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