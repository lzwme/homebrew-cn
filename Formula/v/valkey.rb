class Valkey < Formula
  desc "High-performance data structure server that primarily serves keyvalue workloads"
  homepage "https:valkey.io"
  url "https:github.comvalkey-iovalkeyarchiverefstags8.0.2.tar.gz"
  sha256 "e052c45b3cbe512e24fdfdc3fd337f9f5e4b8f8b8713f349ba867b829c8ff11a"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # depsjemalloc, depslinenoise, srclzf*
    "BSL-1.0", # depsfpconv
    "MIT", # depslua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # depshdr_histogram
  ]
  head "https:github.comvalkey-iovalkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35f28a333d819e4dd79cbaecd9662b76fb2f9bccee9cbc7d1837dc73acf608bd"
    sha256 cellar: :any,                 arm64_sonoma:  "0553629ae98e014e03768c3a1f201647a54d04467349298f824a846d3db001cc"
    sha256 cellar: :any,                 arm64_ventura: "293240ad010c39a8f520f52529cf44ea61c592eeaf24544562446f564767924e"
    sha256 cellar: :any,                 sonoma:        "92dd53977a83863da80ecf5ec78d0dbc23d41b81b7f1b0983e1eb5385239b927"
    sha256 cellar: :any,                 ventura:       "4bf831c8ca2eebcb20ec7249ceb14e09d6e7fcf76a85e55471994757fc4a9879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41c184e0d84bfb12af38cca00cf5310b2ec5bd334a5a9588b01f4c07dd53d37"
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
    %w[run dbvalkey log].each { |p| assert_path_exists varp, "#{varp} doesn't exist!" }
  end
end