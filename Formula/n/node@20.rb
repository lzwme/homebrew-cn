class NodeAT20 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://registry.npmmirror.com/-/binary/node/v20.9.0/node-v20.9.0.tar.xz"
  sha256 "a23d96810abf0455426b349d47ce5310f33095b7bc0571b9cc510f481c3a4519"
  license "MIT"

  livecheck do
    url "https://registry.npmmirror.com/-/binary/node/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "76e99d7791e1e9fca565d4513c6995dd8d71489933a86dbfbc022a3b2d7e3d53"
    sha256 arm64_ventura:  "9d60b9ca5951fd31dcee3a51034b9924bbf836987457fad6cc33ac24a09f1c7c"
    sha256 arm64_monterey: "0c5d93937a4c1026ca22916ab4c4944ead3867808c66c862a21633e6f963fe11"
    sha256 sonoma:         "bf84650372f0654bec9480d057d1b54616894d079fdf44df8ad876e191d8eb9d"
    sha256 ventura:        "1a6fed69e72f611d67032bebbae51054cc6ee49f1617ab5a99688dc9dec42027"
    sha256 monterey:       "ddf39caa4217aaf058434e6e030a646cc28565cf91cb02b605ed2cd25b402878"
    sha256 x86_64_linux:   "2ae0a6d389fd1b2c65cc703ee170481a0ece3a3855d00d6a22b1efd445efdf1b"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2026-04-30", because: :unsupported
  deprecate! date: "2024-10-22", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: calling a private constructor of class 'v8::internal::(anonymous namespace)::RegExpParserImpl<uint8_t>'
    EOS
  end

  fails_with gcc: "5"

  # Support Python 3.12
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The new linker crashed during LTO due to high memory usage.
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.12")

    args = %W[
      --prefix=#{prefix}
      --with-intl=system-icu
      --shared-libuv
      --shared-nghttp2
      --shared-openssl
      --shared-zlib
      --shared-brotli
      --shared-cares
      --shared-libuv-includes=#{Formula["libuv"].include}
      --shared-libuv-libpath=#{Formula["libuv"].lib}
      --shared-nghttp2-includes=#{Formula["libnghttp2"].include}
      --shared-nghttp2-libpath=#{Formula["libnghttp2"].lib}
      --shared-openssl-includes=#{Formula["openssl@3"].include}
      --shared-openssl-libpath=#{Formula["openssl@3"].lib}
      --shared-brotli-includes=#{Formula["brotli"].include}
      --shared-brotli-libpath=#{Formula["brotli"].lib}
      --shared-cares-includes=#{Formula["c-ares"].include}
      --shared-cares-libpath=#{Formula["c-ares"].lib}
      --openssl-use-def-ca-store
    ]

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # Pre-Catalina macOS also can't build with LTO
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if MacOS.version >= :catalina && build.bottle?

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    # Make sure Mojave does not have `CC=llvm_clang`.
    ENV.clang if OS.mac?

    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

    # make sure npm can find node
    ENV.prepend_path "PATH", opt_bin
    ENV.delete "NVM_NODEJS_ORG_MIRROR"
    assert_equal which("node"), opt_bin/"node"
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "ref-napi" unless head?
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end

__END__
diff --git a/configure b/configure
index fefb313c..711a3014 100755
--- a/configure
+++ b/configure
@@ -4,6 +4,7 @@
 # Note that the mix of single and double quotes is intentional,
 # as is the fact that the ] goes on a new line.
 _=[ 'exec' '/bin/sh' '-c' '''
+command -v python3.12 >/dev/null && exec python3.12 "$0" "$@"
 command -v python3.11 >/dev/null && exec python3.11 "$0" "$@"
 command -v python3.10 >/dev/null && exec python3.10 "$0" "$@"
 command -v python3.9 >/dev/null && exec python3.9 "$0" "$@"
@@ -23,7 +24,7 @@ except ImportError:
   from distutils.spawn import find_executable as which

 print('Node.js configure: Found Python {}.{}.{}...'.format(*sys.version_info))
-acceptable_pythons = ((3, 11), (3, 10), (3, 9), (3, 8), (3, 7), (3, 6))
+acceptable_pythons = ((3, 12), (3, 11), (3, 10), (3, 9), (3, 8), (3, 7), (3, 6))
 if sys.version_info[:2] in acceptable_pythons:
   import configure
 else: