class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://ghfast.top/https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "af022f399651aef02704a84a617586ebc67c7df987fecd521c2b0ec6401d30ba"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a73b7344ca0b822699584f4f57fae6eb3782b3e99d1feee0b4ac0a264b191de1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "677d44a8d1d2598cf4613b1e5d4fcb0655f53cc3b140badd85a291a886e48ea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74f1065a9b0cd637eb2083c81895e2658e4138df6d674c8c2ef60dce0199a5a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43a1c4199c95040b2176608ae73e2e84f4fce984927af540c4866138b0863b23"
    sha256 cellar: :any,                 x86_64_linux:      "77aa1fb216b432865537c3d7b85653305daf530ed791a8cd7140da1d69b5d9b1"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "caddy"
  end

  def install
    ldflags = "-X github.com/caddyserver/caddy/v2.CustomVersion=Vulcain.rocks.#{version}"

    cd "caddy" do
      system "go", "build", *std_go_args(ldflags:, tags: "nobadger,nomysql,nopgx"), "./vulcain"
    end
  end

  service do
    run [opt_bin/"vulcain", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/vulcain.log"
    log_path var/"log/vulcain.log"
    environment_variables(
      XDG_DATA_HOME: "#{HOMEBREW_PREFIX}/var/lib",
      HOME:          "#{HOMEBREW_PREFIX}/var/lib",
    )
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/vulcain version")

    (testpath/"Caddyfile").write <<~EOS
      http://127.0.0.1:#{port} {
        respond "Vulcain API"
      }
    EOS

    pid = spawn bin/"vulcain", "run", "--config", testpath/"Caddyfile"

    sleep 2

    assert_match "Vulcain API", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end