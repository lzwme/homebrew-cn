class NodeAT18 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://registry.npmmirror.com/-/binary/node/v18.20.4/node-v18.20.4.tar.xz"
  sha256 "a76c7ea1b96aeb6963a158806260c8094b6244d64a696529d020547b9a95ca2a"
  license "MIT"
  revision 2

  livecheck do
    url "https://registry.npmmirror.com/-/binary/node/"
    regex(%r{href=["']?v?(18(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "1d2ce510cf574da66f4e5c5cf3a8a901b3a01e97698a14f8c01cec83023e0c5d"
    sha256 arm64_sonoma:  "9aaf06ffb456a0771faee9b25b1c46a80480b0b477266bd5068ad884b857cee3"
    sha256 arm64_ventura: "491354ee9860881f2a405278366ddd146509bddcd8962dd4424ccc0afd03c251"
    sha256 sonoma:        "fde7c1f991598524bddeb6097f8ea88b589470fd20bdca34a464dd7f43f1f0f2"
    sha256 ventura:       "1e1d2c42641ab1d6ccecc41d4022cec588edcdcba560ed211c41219ca2bce7a4"
    sha256 x86_64_linux:  "5918442ca75b8961191a876348a16db2686e4668d457c8b7d9e5309d04d2fd02"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2025-04-30", because: :unsupported
  deprecate! date: "2024-10-29", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@76"
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

  # Backport support for ICU 76+
  patch do
    url "https://github.com/nodejs/node/commit/81517faceac86497b3c8717837f491aa29a5e0f9.patch?full_index=1"
    sha256 "79a5489617665c5c88651a7dc364b8967bebdea5bdf361b85572d041a4768662"
  end

  # py3.13 build patch
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.13")

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
    system bin/"npm", *npm_args, "install", "ref-napi"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end

__END__
diff --git a/configure b/configure
index 711a3014..29ebe882 100755
--- a/configure
+++ b/configure
@@ -4,6 +4,7 @@
 # Note that the mix of single and double quotes is intentional,
 # as is the fact that the ] goes on a new line.
 _=[ 'exec' '/bin/sh' '-c' '''
+command -v python3.13 >/dev/null && exec python3.13 "$0" "$@"
 command -v python3.12 >/dev/null && exec python3.12 "$0" "$@"
 command -v python3.11 >/dev/null && exec python3.11 "$0" "$@"
 command -v python3.10 >/dev/null && exec python3.10 "$0" "$@"
@@ -24,7 +25,7 @@ except ImportError:
   from distutils.spawn import find_executable as which
 
 print('Node.js configure: Found Python {}.{}.{}...'.format(*sys.version_info))
-acceptable_pythons = ((3, 12), (3, 11), (3, 10), (3, 9), (3, 8), (3, 7), (3, 6))
+acceptable_pythons = ((3, 13), (3, 12), (3, 11), (3, 10), (3, 9), (3, 8), (3, 7), (3, 6))
 if sys.version_info[:2] in acceptable_pythons:
   import configure
 else: