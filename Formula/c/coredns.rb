class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/coredns/coredns/archive/v1.11.0.tar.gz"
    sha256 "967c12d2b170b7eb46314edf01013d1547932f62e963a68b5e57cc4c10f966b6"

    # quic-go patch for go 1.21.0
    patch do
      url "https://github.com/coredns/coredns/commit/93139841965d8a4e6791dbe2e4d154991fc6a59b.patch?full_index=1"
      sha256 "74f86412ec909879cb690958bc1efe387df045c9f7e6143dc258c1db0673fd88"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ea4d0da4841f1693197e55ac208755b5d78013056173e6c950fcc33d4cff7ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "920b3007051d956295cc37fbc782b8d984ec7cd0a9fbac210829be614da04f7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f4cebabb485f4302601d3db6ef1f3cf8b9c737af447501e75af9b052bed2c2d"
    sha256 cellar: :any_skip_relocation, ventura:        "949d6e309e896853ba99a8321188649260377e0c186f4f4245b014e214b2fb76"
    sha256 cellar: :any_skip_relocation, monterey:       "1e7a954af9e5dc2b4d2ffc25335536b33e036914706dd8c8485e838a47666270"
    sha256 cellar: :any_skip_relocation, big_sur:        "511abebac162224f16186ae0426b2bec625aea76e552a11068d2d2acd41cddce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6daec11ddb450fad7e5e3b2e9206e5bb43cfa1d49ab7538be66c4bc6acd6fd46"
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