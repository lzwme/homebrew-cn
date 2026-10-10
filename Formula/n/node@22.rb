class NodeAT22 < Formula
  desc "Open-source, cross-platform JavaScript runtime environment"
  homepage "https://nodejs.org/"
  url "https://registry.npmmirror.com/-/binary/node/v22.23.3/node-v22.23.3.tar.xz"
  sha256 "bd97093e1a1e9243338950c174a693a64d4e0926a9c6ce259962bc58d5e96909"
  license "MIT"
  revision 2
  compatibility_version 1

  livecheck do
    url "https://registry.npmmirror.com/-/binary/node/"
    regex(%r{href=["']?v?(22(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eba99a8453566a8dc844fa0b67fe5b11126cd08ca267fd7d2df6aa81655f1f75"
    sha256 cellar: :any, arm64_tahoe:       "0762c7c68cc37e7a194500ef155129181a0b8b9e57eb2c47473199ca7f27abdc"
    sha256 cellar: :any, arm64_sequoia:     "906a394fe3cd1acd61c2ed0207b58c142e3a1592e3bf858deae47dd99c7dbf07"
    sha256 cellar: :any, arm64_linux:       "c160b47ad07d925b68b5aabb4f517874b9d95470f35a9c7f6a2b454a13e7fc9f"
    sha256 cellar: :any, x86_64_linux:      "9c7c66c364cafd8a0f064146f09a14480c2db517fe8d714ed9419a677019e8a7"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2027-04-30", because: :unsupported
  deprecate! date: "2026-10-28", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@78"
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "simdjson"
  depends_on "simdutf"
  depends_on "sqlite"
  depends_on "uvwasi"
  depends_on "zstd"

  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = python3
    # simdjson 5 `key_selector` uses `throw` in consteval, which clang <= 20 rejects with -fno-exceptions
    ENV.append "CXXFLAGS", "-DSIMDJSON_CONCEPT_DISABLED"

    args = %W[
      --prefix=#{prefix}
      --with-intl=system-icu
      --shared
      --shared-brotli
      --shared-cares
      --shared-libuv
      --shared-nghttp2
      --shared-nghttp3
      --shared-openssl
      --shared-simdjson
      --shared-simdutf
      --shared-sqlite
      --shared-uvwasi
      --shared-zlib
      --shared-zstd
      --shared-brotli-includes=#{formula_opt_include("brotli")}
      --shared-brotli-libpath=#{formula_opt_lib("brotli")}
      --shared-cares-includes=#{formula_opt_include("c-ares")}
      --shared-cares-libpath=#{formula_opt_lib("c-ares")}
      --shared-libuv-includes=#{formula_opt_include("libuv")}
      --shared-libuv-libpath=#{formula_opt_lib("libuv")}
      --shared-nghttp2-includes=#{formula_opt_include("libnghttp2")}
      --shared-nghttp2-libpath=#{formula_opt_lib("libnghttp2")}
      --shared-nghttp3-includes=#{formula_opt_include("libnghttp3")}
      --shared-nghttp3-libpath=#{formula_opt_lib("libnghttp3")}
      --shared-openssl-includes=#{formula_opt_include("openssl@3")}
      --shared-openssl-libpath=#{formula_opt_lib("openssl@3")}
      --shared-simdjson-includes=#{formula_opt_include("simdjson")}
      --shared-simdjson-libpath=#{formula_opt_lib("simdjson")}
      --shared-simdutf-includes=#{formula_opt_include("simdutf")}
      --shared-simdutf-libpath=#{formula_opt_lib("simdutf")}
      --shared-sqlite-includes=#{formula_opt_include("sqlite")}
      --shared-sqlite-libpath=#{formula_opt_lib("sqlite")}
      --shared-uvwasi-includes=#{formula_opt_include("uvwasi")}/uvwasi
      --shared-uvwasi-libpath=#{formula_opt_lib("uvwasi")}
      --shared-zstd-includes=#{formula_opt_include("zstd")}
      --shared-zstd-libpath=#{formula_opt_lib("zstd")}
      --openssl-use-def-ca-store
    ]

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && build.bottle?

    # TODO: Try to devendor these libraries.
    # - `--shared-ada` needs the `ada-url` formula, but requires C++20
    # - `--shared-http-parser` and `--shared-uvwasi` are not available as dependencies in Homebrew.
    ignored_shared_flags = %w[
      ada
      http-parser
      ngtcp2
    ].map { |library| "--shared-#{library}" }

    configure_help = Utils.safe_popen_read("./configure", "--help")
    shared_flag_regex = /\[(--shared-[^ \]]+)\]/
    configure_help.scan(shared_flag_regex) do |matches|
      matches.each do |flag|
        next if args.include?(flag) || ignored_shared_flags.include?(flag)

        odie "Unused `--shared-*` flag: #{flag}"
      end
    end

    system "./configure", *args
    system "make", "install"

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
    assert_path_exists bin/"npm", "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "nan"
    assert_path_exists bin/"npx", "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")

    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/npm config get prefix").chomp
  end
end