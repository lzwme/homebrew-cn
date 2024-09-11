class NodeAT20 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://registry.npmmirror.com/-/binary/node/v20.17.0/node-v20.17.0.tar.xz"
  sha256 "9abf03ac23362c60387ebb633a516303637145cb3c177be3348b16880fd8b28c"
  license "MIT"

  livecheck do
    url "https://registry.npmmirror.com/-/binary/node/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia:  "bd8e7d976f5c9fbf248802eadc7c4559bb467aecab667581058205bf37188c60"
    sha256 arm64_sonoma:   "69e82b4f11cf002776892d0576fedd78a77b03dbbc5712163dad46859d40a18d"
    sha256 arm64_ventura:  "400af32a0afc9de914df08a3170c5ad751f7fa5c659e4f75f57845a98c92f6b7"
    sha256 arm64_monterey: "a89cd12cb649ba14bca37c882c4c709c18d0c276a36393676669da51e609446a"
    sha256 sonoma:         "a66f44eaca2b373732556ff45bbb3434e84736a40aa85bd894d0edfcc9fc8b42"
    sha256 ventura:        "53b736b679ac8da42dcbd1d92097d6ffd9e763b0176920309073e1723ad74e74"
    sha256 monterey:       "865409db21de6a591aef15bc03ec627e44287e78506bfcd628020c84f9b3a062"
    sha256 x86_64_linux:   "7a7686cab5b96cf61ae8af6d95d2ab2162f12b82ed0fcc9f2136ef9219a3a2db"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2026-04-30", because: :unsupported
  deprecate! date: "2025-10-28", because: :unsupported

  depends_on "pkg-config" => :build
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
    args << "--enable-lto" if OS.mac? && MacOS.version >= :catalina && build.bottle?

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