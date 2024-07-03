class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240702.tar.gz"
  sha256 "e404aaa5b2cbe3cfa654d7d00403af298a1649c1003595f03e637ef12e336a47"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2da7a369f03a00abc9ef73249e314a5fb01034055570d40d0506ca106e2e5a44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d90face0aec81a93451be0baba236fb327c2ee4f5502874e760a79e2dec441b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f27277ec9a8a23b9309ad14ad99f4098c3bd14db9569c68592e26666188809f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c0f68b4ae7e7860d3464de9dc37325a72d7153040199813ef910c3cee24d6fe"
    sha256 cellar: :any_skip_relocation, ventura:        "622051486536f0dcca4cdaf1114d6c49b6427b65ac6c051024a6e9b6ee49940b"
    sha256 cellar: :any_skip_relocation, monterey:       "42ada2858f38a5afab813bd533d54f4bb6f726d987638ba31c1e5238fca41a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a23f77888a144957c22961971b287612edf1c41fbdc39c2d33be6ae7e056964"
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