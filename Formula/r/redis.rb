class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.10.2.tar.gz"
  sha256 "b9ffee226b5eecdba98a679260dad764b2a4ebd90dce4ad5ac9e9f3eef9c02b3"
  license all_of: [
    "AGPL-3.0-only", # modules: VectorSimilarity, LibMR
    "Apache-2.0", # modules: ScalableVectorSearch, cpu_features, friso, cndict
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*, deps/tre, deps/xxhash, modules: bloom
    "BSD-3-Clause", # modules: libevent, hiredis, readies, snowball, stemmers
    "BSL-1.0", # deps/fpconv, modules: boost, eve, dragonbox, fast_double_parser
    "MIT", # deps/lua, modules: fmt, spdlog, robin-map, tomlplusplus, fast_float, t-digest-c, libnu, libuv, miniz
    { any_of: ["CC0-1.0", "BSD-2-Clause"] }, # deps/hdr_histogram
    any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"], # modules: phonetics
  ]
  revision 1
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "da7b1843daf46f283876df1ac40e77f31cc30f58790a690e8d6f2765e447103e"
    sha256 cellar: :any, arm64_tahoe:       "dceaa39c2157f6654f17430893d452049cf8f08ce3395f56aaf6fb9a0b8b8ed1"
    sha256 cellar: :any, arm64_sequoia:     "136196e0ed4582a8e950719ab3caa8e445b63ea615cd1eef85c73e483ef505a7"
    sha256 cellar: :any, arm64_linux:       "aaa76f55e5ba3c70fefb39e82ac0b500ece7793e92b6e33d2e3e460d038ce31f"
    sha256 cellar: :any, x86_64_linux:      "37db9912d48dc36edb6b8c5b2f6b52d0f7edb96cd6e75e1efce35c1d79ddcc8f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build # RediSearch needs Make 4.0+
  end

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    # VectorSimilarity selects its SIMD kernels at runtime via cpu_features.
    ENV.runtime_cpu_detection
    # FIXME: redisbloom's vendored readies has no `OSX_MIN_SDK_VER` past tahoe, leaving `-mmacosx-version-min=` empty
    ENV["OSX_MIN_SDK_VER"] = MacOS.version.to_s if OS.mac?
    # RediSearch looks for Homebrew's `openssl@3` before anything else on macOS
    inreplace "modules/redisearch/src/CMakeLists.txt",
              "/opt/homebrew/opt/openssl@3", formula_opt_prefix("openssl@4")
    system "gmake", "deploy", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes",
           "BUILD_COMPRESSION=yes", "REDISEARCH_GENERATE_HEADERS=0", "IGNORE_MISSING_DEPS=1", "LTO=0"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
      s.gsub! "#{lib}/redis/modules", "#{opt_lib}/redis/modules"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  post_install_steps do
    # The modules are plugins that redis opens rather than links against, it checks that
    # an execute bit is set and fails otherwise.
    set_permissions "redis/modules/*", "0755", base: :lib
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }

    # Test that all modules can be loaded
    %w[redisbloom.so rejson.so redisearch.so redistimeseries.so].each do |file|
      output = shell_output("#{bin}/redis-server --loadmodule #{lib/"redis/modules"/file} --test-memory 2 2>&1", 1)
      assert_match(/Module.*loaded from/, output)
    end
  end
end