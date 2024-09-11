class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https:redis.io"
  # NOTE: Do not bump to v7.4+ as license changed to RSALv2+SSPLv1
  # https:github.comredisredispull13157
  url "https:download.redis.ioreleasesredis-7.2.5.tar.gz"
  sha256 "5981179706f8391f03be91d951acafaeda91af7fac56beffb2701963103e423d"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # depsjemalloc, depslinenoise, srclzf*
    "BSL-1.0", # depsfpconv
    "MIT", # depslua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # depshdr_histogram
  ]
  head "https:github.comredisredis.git", branch: "unstable"

  livecheck do
    url "https:download.redis.ioreleases"
    regex(href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.ti)
    strategy :page_match do |page, regex|
      version_limit = Version.new("7.4")
      page.scan(regex).map do |match|
        match[0] if Version.new(match[0]) < version_limit
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "13a841f5d3375fd9363a99a559bf74ea7c24e7d4853475e3e01c05d039c3010c"
    sha256 cellar: :any,                 arm64_sonoma:   "bc4c2bb74037b80b2566938f7249c1052f8e493af8ee7b57e5ee14e19c19411e"
    sha256 cellar: :any,                 arm64_ventura:  "c40b3cf2351377a3e71d5a8562b4a62e94b65cb736d3438b67465cf2aacecf2e"
    sha256 cellar: :any,                 arm64_monterey: "c749644cda76a63f76cbc39fd8f2021ab959a4e1eb8c8ff5dfe5638803c80333"
    sha256 cellar: :any,                 sonoma:         "1415fc1040dff3bd1955d3440d9627d80a23d623801cc4b16cb07b9d4a921c0b"
    sha256 cellar: :any,                 ventura:        "9c5f7c63a52f880ecf43d44d533a3b4c05089030442e1652cdfe3cc7ea88ed93"
    sha256 cellar: :any,                 monterey:       "4c97e9718bd50ee80e139936e0b5fb6fd73879051ed7e9d6bddc5eae0d671347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d782e9fcee0d8a104ba5071709fb183ce77edb40f153c971001baaa025029910"
  end

  depends_on "openssl@3"

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    odie "Do not bump to v7.4+" if version.major_minor >= "7.4"

    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run dbredis log].each { |p| (varp).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "varrunredis_6379.pid", var"runredis.pid"
      s.gsub! "dir .", "dir #{var}dbredis"
      s.sub!(^bind .*$, "bind 127.0.0.1 ::1")
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin"redis-server", etc"redis.conf"]
    keep_alive true
    error_log_path var"logredis.log"
    log_path var"logredis.log"
    working_dir var
  end

  test do
    system bin"redis-server", "--test-memory", "2"
    %w[run dbredis log].each { |p| assert_predicate varp, :exist?, "#{varp} doesn't exist!" }
  end
end