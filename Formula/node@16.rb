class NodeAT16 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://registry.npmmirror.com/-/binary/node/v16.20.1/node-v16.20.1.tar.xz"
  sha256 "83e03381e271f1a5619188e7aea9d85d9b7e12f5be2a28ceb78d7249ed22b7f1"
  license "MIT"

  livecheck do
    url "https://registry.npmmirror.com/-/binary/node/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "132e3987602300694ac7cd4481437dc8e3f573d2b255b1be7eaa76b505d4d919"
    sha256 cellar: :any,                 arm64_monterey: "d38941095893e3ddc6a95b57ac2afdc0d8b4370f2a6f6e28e86d8475dd4dd72d"
    sha256 cellar: :any,                 arm64_big_sur:  "841868d01f650baa52b76fc15e6cb58af5372c695a865cf65887df3af7d76f87"
    sha256 cellar: :any,                 ventura:        "2f18e5a7c1d139372cc551f6097fe0343ed1b85cf0fe7757d13a716e39582f8e"
    sha256 cellar: :any,                 monterey:       "cd4c21ce4bbbd02f840f49da5d604b43b70308e86f400a0f2956aca75d26434a"
    sha256 cellar: :any,                 big_sur:        "64e82f51db8dae485684ca2158f8f0c0db393fb4494f8cee9559adeb76d1abb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c935593186670f001cce94883beeac95ecfafa4bc37bc07bfec42a09183d2860"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2023-09-11", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  fails_with :clang do
    build 1099
    cause "Node requires Xcode CLT 11+"
  end

  fails_with gcc: "5"

  def install
    python3 = "python3.11"
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which(python3)

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
      --shared-openssl-includes=#{Formula["openssl@1.1"].include}
      --shared-openssl-libpath=#{Formula["openssl@1.1"].lib}
      --shared-brotli-includes=#{Formula["brotli"].include}
      --shared-brotli-libpath=#{Formula["brotli"].lib}
      --shared-cares-includes=#{Formula["c-ares"].include}
      --shared-cares-libpath=#{Formula["c-ares"].lib}
      --openssl-use-def-ca-store
    ]
    system python3, "configure.py", *args
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
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
    system "#{bin}/npm", *npm_args, "install", "npm@latest"
    system "#{bin}/npm", *npm_args, "install", "ref-napi"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end