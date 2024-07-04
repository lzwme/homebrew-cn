class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https:github.comxtacikcptun"
  url "https:github.comxtacikcptunarchiverefstagsv20240703.tar.gz"
  sha256 "095709bb47b13f818a4e0109a28be7117c4bddc9304e6fbb452edefc80fb624c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d0873c3e9ff8a1f739522111280120c628f11cff55f01747b490fa44f34e655"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7ce564c3df68460a8ae1d29695878638e65cb29423ad1d6f76550d821a951f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5c9cd1a57ada450248e0cdf6242cbc9399a2acd661cf3e417a4bf727da1395"
    sha256 cellar: :any_skip_relocation, sonoma:         "72f581371303696d2839d19dc5aee1ff93603cb3554c91e82fb0d8dbad88b2e3"
    sha256 cellar: :any_skip_relocation, ventura:        "e203233b761f1490da0058d37753940818040c206b238299f152792dbc5e5675"
    sha256 cellar: :any_skip_relocation, monterey:       "f627aa64947ce5d167f946397621dec3382fdbbd599f798f8b8fdbc2f0ebc542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12b9ff573c9bc0995750e4e3e6b6780ccca67b2aa3542ee91495735a3ac45c6"
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