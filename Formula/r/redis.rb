class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.10.1.tar.gz"
  sha256 "60166c95ab7aedaa9dfe516de685be0a4dd87be95ded59ba429df14c13f1b663"
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
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "b8605b39f8fc0ee614d59e2e24b3943823adb4efb9a884b5c854d30f9bae184d"
    sha256 cellar: :any, arm64_tahoe:       "cc958259d62cfa7b13f9609eca12ec8c24f5e033e7356b5e68a9b4aaa855cc5c"
    sha256 cellar: :any, arm64_sequoia:     "e516dbc5d61583511914c9a301b8d2ce5b2d69e069dadf1b44151a984a8b05b7"
    sha256 cellar: :any, arm64_linux:       "dcbbabc443b0a19a31a184eee89b69b682b05ac834df0789d3c0c5e92305ba43"
    sha256 cellar: :any, x86_64_linux:      "93dd800bc10884a868d69cfe92d988f817f83d62f16bc9388809fa3d0e793d1b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build

  on_macos do
    depends_on "make" => :build # RediSearch needs Make 4.0+
  end

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    # RediSearch sets `CMAKE_CXX_STANDARD` inside a function without `PARENT_SCOPE`,
    # so no `-std` reaches the compile line and the compiler default is used instead.
    ENV.append "CXXFLAGS", "-std=gnu++20"
    # VectorSimilarity selects its SIMD kernels at runtime via cpu_features.
    ENV.runtime_cpu_detection
    # FIXME: redisbloom's vendored readies has no `OSX_MIN_SDK_VER` past tahoe, leaving `-mmacosx-version-min=` empty
    ENV["OSX_MIN_SDK_VER"] = MacOS.version.to_s if OS.mac?
    system "gmake", "deploy", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes",
           "REDISEARCH_GENERATE_HEADERS=0", "IGNORE_MISSING_DEPS=1", "LTO=0"

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