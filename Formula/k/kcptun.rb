class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240825.tar.gz"
  sha256 "f0e8828fff6033df47cc020ebe83deff7ab438188dca5f79b9f23f49a98d0730"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b82edfb164b6f65af4aba1f85d47f9edd41a7b4e8e91024ec530024aeee7057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b82edfb164b6f65af4aba1f85d47f9edd41a7b4e8e91024ec530024aeee7057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b82edfb164b6f65af4aba1f85d47f9edd41a7b4e8e91024ec530024aeee7057"
    sha256 cellar: :any_skip_relocation, sonoma:         "01554d2305761e31a4aa91744837b066d382682d32325a03568d4f4187ee2db9"
    sha256 cellar: :any_skip_relocation, ventura:        "01554d2305761e31a4aa91744837b066d382682d32325a03568d4f4187ee2db9"
    sha256 cellar: :any_skip_relocation, monterey:       "01554d2305761e31a4aa91744837b066d382682d32325a03568d4f4187ee2db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f26c8a3d32cfbe3857a9f513f9552d89e890657d4778373c5fa07279781b888"
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