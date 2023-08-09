class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://ghproxy.com/https://github.com/coredns/coredns/archive/v1.11.0.tar.gz"
  sha256 "967c12d2b170b7eb46314edf01013d1547932f62e963a68b5e57cc4c10f966b6"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be5388add1e31e7c0e375a233086aec14cf0acec43d177e26bfc6a2e53a7fa98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3081b32d6aff80ac985d36d632cf88679b0c60c8e6e2eecef4b0c00e0e6abf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78c976f87a883b19b5907bb882e9425dd2983ae809d3d71cab7fde9454f19f63"
    sha256 cellar: :any_skip_relocation, ventura:        "2a45b1af863de7489370c29c7f73f6645d714630c4ed8e4d6896f9a39fbeb042"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef656198bff60e8c0f591af1224450822ff1eb852ae230a632a061ebcaf2479"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d47a51d9d07f5cae0eb62e9c9f3a6a942c9891ab38867135e8e76869e0675ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57da7301d34bad9f484dc19722fee1ae540d05f45f8121791d10abad69fd46f5"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end