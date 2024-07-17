class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240716.tar.gz"
  sha256 "60d0f0f55e046ad095d072a7955fadfd99993d708db5b6a8b44221a5cca79c08"
  license "MIT"
  head "https:github.comxtacikcptun.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)*)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "078105759f892c935f889c699715fd828f72b46c0377de40709ea8d684358086"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a12fb176b8304194dd9f9ff27ef1e3d71b2d80c3da5695c03136edc0f304a2b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef1a2cd1a3f43b4493cfebda6d007b417bc809e64a50bce2121dc6e4d6f15eee"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d56401812677603029b963a9067d680af9ac3daee9256c08e12a6615cd3e543"
    sha256 cellar: :any_skip_relocation, ventura:        "c9158705f78da37cb625418e3fec089a05af395fb4869f0d3201aa9bab15afec"
    sha256 cellar: :any_skip_relocation, monterey:       "d678b2d1dd0f8f02de379f2e01a10336312fe209b93f6250464a4ca80143f522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ade7ad029995d1fbdc48eb7d85763318ca906b138bdc4ed747b399200e79de"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_client"), ".client"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_server"), ".server"

    etc.install "exampleslocal.json" => "kcptun_client.json"
  end

  service do
    run [opt_bin"kcptun_client", "-c", etc"kcptun_client.json"]
    keep_alive true
    log_path var"logkcptun.log"
    error_log_path var"logkcptun.log"
  end

  test do
    server = fork { exec bin"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http:127.0.0.1:12948")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end