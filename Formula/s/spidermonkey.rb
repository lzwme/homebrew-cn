class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https:spidermonkey.dev"
  url "https:archive.mozilla.orgpubfirefoxreleases128.10.1esrsourcefirefox-128.10.1esr.source.tar.xz"
  version "128.10.1"
  sha256 "e85b25dea98bfa400940e0f79aa82a190b445d848b00d19f801a647598fda0b9"
  license "MPL-2.0"
  head "https:hg.mozilla.orgmozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https:download.mozilla.org?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5319ce1ca09d0e6a1d80e4c4627dda336257bc96437482bbe1895f42499f5143"
    sha256 cellar: :any, arm64_sonoma:  "ea80b1e53c8f4f7dbb7e7ce83e64e8621a40d2766c420837dc828f8788f20b3c"
    sha256 cellar: :any, arm64_ventura: "42a8f338c9e9dd50250cd96330901b89a35eae9ba4b71002ec0da208767d1def"
    sha256 cellar: :any, sonoma:        "1e036749da7e90ef023b4877bed62d61777c55165f77b549ff78057353ad942f"
    sha256 cellar: :any, ventura:       "1c8a6cfd45f4a50b334227f001273e10ab43d037edb9e28ea10d75c3f44dcf7e"
    sha256               arm64_linux:   "a10e099013278d0a77c6992951ae4e98b4bf2c9f4844731a449e5f2f956b77f4"
    sha256               x86_64_linux:  "36f51d45dbd9a41aed68239785ecb3c6c71460797c009727e446d760df53af4d"
  end

  depends_on "cbindgen" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
      url "https:github.comptomatomozjscommitc82346c4e19a73ed4c7f65a6b274fc2138815ae9.patch?full_index=1"
      sha256 "0f1cd5f80b4ae46e614efa74a409133e8a69fff38220314f881383ba0adb0f87"
    end
  end

  # Fix to find linker on macos-15, abusing LD_PRINT_OPTIONS is not working
  # Issue ref: https:bugzilla.mozilla.orgshow_bug.cgi?id=1964280
  patch :DATA

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

__END__
diff --git abuildmoz.configuretoolchain.configure bbuildmoz.configuretoolchain.configure
index 264027e..2e073a3 100644
--- abuildmoz.configuretoolchain.configure
+++ bbuildmoz.configuretoolchain.configure
@@ -1906,7 +1906,16 @@ def select_linker_tmpl(host_or_target):
                 kind = "ld64"
 
             elif retcode != 0:
-                return None
+                # macOS 15 fallback: try `-Wl,-v` if --version failed
+                if target.kernel == "Darwin":
+                    fallback_cmd = cmd_base + linker_flag + ["-Wl,-v"]
+                    retcode2, stdout2, stderr2 = get_cmd_output(*fallback_cmd, env=env)
+                    if retcode2 == 0 and "@(#)PROGRAM:ld" in stderr2:
+                        kind = "ld64"
+                    else:
+                        return None
+                else:
+                    return None
 
             elif "mold" in stdout:
                 kind = "mold"