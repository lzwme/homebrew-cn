class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20241031.tar.gz"
  sha256 "f3430de60f219bdd8d4d57468e827559791ae63ce0b84f50840b24b45647a8f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33cb82d01cc4dec46c37b9d4d4ab34753797f3c9fd7298c12207b73f3b8c0c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33cb82d01cc4dec46c37b9d4d4ab34753797f3c9fd7298c12207b73f3b8c0c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33cb82d01cc4dec46c37b9d4d4ab34753797f3c9fd7298c12207b73f3b8c0c1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "29560c38dbcf8b1fd3f2d1c69d65b25b482a09cb7d597ac5f0a0eee958bdd4bc"
    sha256 cellar: :any_skip_relocation, ventura:       "29560c38dbcf8b1fd3f2d1c69d65b25b482a09cb7d597ac5f0a0eee958bdd4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfb8549854d52ccbd8b752e1b146d7c498b9e5490abc6d0c09b4c53c19e63e1"
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