class NodeAT18 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://registry.npmmirror.com/-/binary/node/v18.18.1/node-v18.18.1.tar.xz"
  sha256 "c3c95047ec0c2b2063a5ea4b4f71ee807f6075d1dbeae4f3207cda4b9ae782f6"
  license "MIT"

  livecheck do
    url "https://registry.npmmirror.com/-/binary/node/"
    regex(%r{href=["']?v?(18(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "23275ebc740f7b7e38b4dd310ac6bc3ee333df6754594c20e244f5b3eec5e20d"
    sha256 arm64_ventura:  "da49a1876961000e123ed50d518a07d3f9cb9ddeafd40e3f3e0bc4630d25a744"
    sha256 arm64_monterey: "1339738623fed1107c191702a2b8063a0c86796a3ffaf484a8d0b3f8a9edef68"
    sha256 sonoma:         "efa709ea377c80bc81cf46a61d0cee489d8046e1a2f3ade4321066e8bb163c39"
    sha256 ventura:        "7986dfebc29fd7a32a4f289caecc1bcbd966ab90a9fb1a9d234acf8d72d883bb"
    sha256 monterey:       "d22060221281e05aa532401498a51b1493b441a0f21f78a63432ce844a449bcd"
    sha256 x86_64_linux:   "84a0284352c80096c958e2699600e824262a5ce35b57dd99c57478cf502bd939"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2025-04-30", because: :unsupported
  deprecate! date: "2023-10-18", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.11")

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
    system bin/"npm", *npm_args, "install", "ref-napi" unless head?
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end