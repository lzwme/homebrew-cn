class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240730.tar.gz"
  sha256 "5df860bf29fca4db7c9a716f9704bec3e02df6fc6e93b4f8a8c9960d572194e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a90f29533519f7d24b34e2376c8b095be6664cfa39e1b18f7b1fb38807e2184"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6c5408b75c72e55f28f95ca97413348692571e095a04696ed5869f9eb113264"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fe6bbabc22b7f3bc02f44f3eff1cd9f59fc395719d70a3721a6f4532ac165bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c66f334c0df783495b43a8369856b3c7ed02f2f5c9bcc189ff1eabc21878cde"
    sha256 cellar: :any_skip_relocation, ventura:        "7e6b4dc79a841c65f018e5df5ba1bde5ca6f083036261c8304da11c61dc7aeb2"
    sha256 cellar: :any_skip_relocation, monterey:       "e910134c078d67949522c476e330d3448bdb523fee242000d6dfe613299a6993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c39eea0ff627e13fad5909fdf5b89dc44c03fa1696f001422b3044a37a955d4a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_client"), ".client"
    system "go", "build", *std_go_args(ldflags:, output: bin"kcptun_server"), ".server"

    etc.install "distlocal.json.example" => "kcptun_client.json"
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