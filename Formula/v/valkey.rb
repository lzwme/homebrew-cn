class Valkey < Formula
  desc "High-performance data structure server that primarily serves keyvalue workloads"
  homepage "https:valkey.io"
  url "https:github.comvalkey-iovalkeyarchiverefstags8.0.0.tar.gz"
  sha256 "f87fef2ba81ae4bce891b874fba58cfde2d19370a3bcac20f0e17498b33c33c0"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # depsjemalloc, depslinenoise, srclzf*
    "BSL-1.0", # depsfpconv
    "MIT", # depslua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # depshdr_histogram
  ]
  head "https:github.comvalkey-iovalkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cae8005dbf1d79a0821fe1b83af8fc60f4a69234758463a554202c593e14b745"
    sha256 cellar: :any,                 arm64_sonoma:  "1ab613c14c0635595ec2e41e77391c341fa15f3b0660be45a166c758018d970a"
    sha256 cellar: :any,                 arm64_ventura: "19be366faa4a5130cb4e00e4a764645f1ebfc7a49d854889676d8597e054d65c"
    sha256 cellar: :any,                 sonoma:        "a767da82905be5a2736b4390cde2f7916632747ac80a37ab6beca70e9b18ce39"
    sha256 cellar: :any,                 ventura:       "21be39a3eac33c660db7ee2b3134b949d69e7109248d277ac4a21b86b1bc8f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df273423a0741c10ec55306fa044ee6a1cf3e66cb3791d4571ff83d0ba9162e"
  end

  depends_on "openssl@3"

  conflicts_with "redis", because: "both install `redis-*` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run dbvalkey log].each { |p| (varp).mkpath }

    # Fix up default conf file to match our paths
    inreplace "valkey.conf" do |s|
      s.gsub! "varrunvalkey_6379.pid", var"runvalkey.pid"
      s.gsub! "dir .", "dir #{var}dbvalkey"
      s.sub!(^bind .*$, "bind 127.0.0.1 ::1")
    end

    etc.install "valkey.conf"
    etc.install "sentinel.conf" => "valkey-sentinel.conf"
  end

  service do
    run [opt_bin"valkey-server", etc"valkey.conf"]
    keep_alive true
    error_log_path var"logvalkey.log"
    log_path var"logvalkey.log"
    working_dir var
  end

  test do
    system bin"valkey-server", "--test-memory", "2"
    %w[run dbvalkey log].each { |p| assert_predicate varp, :exist?, "#{varp} doesn't exist!" }
  end
end