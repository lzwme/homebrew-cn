class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240906.tar.gz"
  sha256 "99fb4efa4429309f6e67b59003077fb1378f316eb003e7da37377fd4a371e428"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1c9bb979b3dff5f05de263279f5dda1b5494287b924fa1ee8f485d96bc73b60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c9bb979b3dff5f05de263279f5dda1b5494287b924fa1ee8f485d96bc73b60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c9bb979b3dff5f05de263279f5dda1b5494287b924fa1ee8f485d96bc73b60"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd461b42d48564e7c999bcae3d27b536a049ed214b37b29edeacb804d9e11edf"
    sha256 cellar: :any_skip_relocation, ventura:        "fd461b42d48564e7c999bcae3d27b536a049ed214b37b29edeacb804d9e11edf"
    sha256 cellar: :any_skip_relocation, monterey:       "fd461b42d48564e7c999bcae3d27b536a049ed214b37b29edeacb804d9e11edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3bc3e067aa0cab04d8ce26efa20baddf4f8c2bfeedcd2edc3d3a19a01ced731"
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