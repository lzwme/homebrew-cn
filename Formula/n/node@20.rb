class NodeAT20 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://registry.npmmirror.com/-/binary/node/v20.8.1/node-v20.8.1.tar.xz"
  sha256 "f799c66f6a6386bb8ac2c75a378f740c455e97f1fe964393dd39c9f9f6efbc70"
  license "MIT"

  livecheck do
    url "https://registry.npmmirror.com/-/binary/node/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "90457fea276a285c7c50facc1a4c3bcf1185c450c3d101bc07bd318a53a98e1c"
    sha256 arm64_ventura:  "fc31441cb84987270d3ea897ecbc3edab6f3826e44d7b10d7b2d9f80713134e0"
    sha256 arm64_monterey: "c840e438adf6475d01721b3805aa065ce88c20845cc7315efc6473f6f91d7869"
    sha256 sonoma:         "5fb752db4c331ba4278f64c6ebbe695d34f62a11930cd62b506fd74ff7e55d85"
    sha256 ventura:        "1c2c5b0c5b99275308781998875828f6aedb4539f031a490e9d7e9254f962568"
    sha256 monterey:       "0285b304cbe9feeb6e2bfc2a6a359b1bd3cde7ec83a7893583382e7a86c835fd"
    sha256 x86_64_linux:   "6025742b665ccc1ccf8cc14fa7f4ef00f86e05e88aba498805ff968aeba687fc"
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