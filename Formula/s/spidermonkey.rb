class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases115.12.0esrsourcefirefox-115.12.0esr.source.tar.xz"
  version "115.12.0"
  sha256 "b59e1625a0bb2f0565a737394f2bf8a7ce3171314b0d871bde533a101847a8ef"
  license "MPL-2.0"
  head "https:hg.mozilla.orgmozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:www.mozilla.orgen-USfirefoxreleases"
    regex(data-esr-versions=["']?v?(\d+(?:\.\d+)+)["' >]i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "509cef16d227f8845c5492fb97c592c9b92622c66542c2c707190ab7d908b65f"
    sha256 cellar: :any, arm64_ventura: "e0c581b4a4d6cede59ad0b517e8bcb91cf462efd7f7bf99ae908182a294aa155"
    sha256 cellar: :any, sonoma:        "b9835f0c1a43e6c6e27f32d11f5de4614a1cc6b345494acdf2a3e57a2b495684"
    sha256 cellar: :any, ventura:       "fc13b23e1fefc3ec377b90fc140ac3cb94861be6f00fecc61b7d7047260c6617"
    sha256               x86_64_linux:  "a520b04bbf643680d0650d8eaf022db5498b9b33b82eeff265f770517e5c264b"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # https:bugzilla.mozilla.orgshow_bug.cgi?id=1857515
  depends_on "rust" => :build
  depends_on macos: :ventura # minimum SDK version 13.3
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "icu4c"
    depends_on "nspr"
  end

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
      url "https:github.comptomatomozjscommit9f778cec201f87fd68dc98380ac1097b2ff371e4.patch?full_index=1"
      sha256 "a772f39e5370d263fd7e182effb1b2b990cae8c63783f5a6673f16737ff91573"
    end
  end

  def install
    # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
    if DevelopmentTools.clang_build_version >= 1500
      inreplace "buildmoz.configuretoolchain.configure", '"-Wl,--version"', '"-Wl,-ld_classic,--version"'
    end

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-shared-js
        --disable-bootstrap
        --disable-debug
        --disable-jemalloc
        --with-intl-api
        --with-system-zlib
      ]
      if OS.mac?
        # Force build script to use Xcode install_name_tool
        ENV["INSTALL_NAME_TOOL"] = DevelopmentTools.locate("install_name_tool")
      else
        # System libraries are only supported on Linux and build fails if args are used on macOS.
        # Ref: https:bugzilla.mozilla.orgshow_bug.cgi?id=1776255
        args += %w[--with-system-icu --with-system-nspr]
      end

      system "..jssrcconfigure", *args
      system "make"
      system "make", "install"
    end

    (lib"libjs_static.ajs").unlink

    # Add an unversioned `js` to be used by dependents like `jsawk` & `plowshare`
    ln_s bin"js#{version.major}", bin"js"
    return unless OS.linux?

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