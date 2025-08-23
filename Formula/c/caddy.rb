class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://ghfast.top/https://github.com/caddyserver/caddy/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "944ab8ba4a8a497827b16b51a39b45dc6e69c32e49d39486d9da198a7727b8be"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afd2a7e4f5a49158e78d3d43d0476b7fd325510e5dec0ee694b1f9256066d1ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afd2a7e4f5a49158e78d3d43d0476b7fd325510e5dec0ee694b1f9256066d1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afd2a7e4f5a49158e78d3d43d0476b7fd325510e5dec0ee694b1f9256066d1ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e43fa79cdc7fc0332e1d9778c857df58b85d34629f8f254feabeacedf0eb5b99"
    sha256 cellar: :any_skip_relocation, ventura:       "e43fa79cdc7fc0332e1d9778c857df58b85d34629f8f254feabeacedf0eb5b99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "746189a9c5941bf07ce25ec94b251c575f84a14a7fad2aac904967ce83770bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87edc8a4699e1bef40c814261259bf83672cb79dbc25b3dfc002002c1d4d08b2"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://ghfast.top/https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.4.5.tar.gz"
    sha256 "53c6a9e29965aaf19210ac6470935537040e782101057a199098feb33c2674f8"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end

    generate_completions_from_executable("go", "run", "cmd/caddy/main.go", "completion")

    system bin/"caddy", "manpage", "--directory", buildpath/"man"

    man8.install Dir[buildpath/"man/*.8"]
  end

  def caveats
    <<~EOS
      When running the provided service, caddy's data dir will be set as
        `#{HOMEBREW_PREFIX}/var/lib`
        instead of the default location found at https://caddyserver.com/docs/conventions#data-directory
    EOS
  end

  service do
    run [opt_bin/"caddy", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/caddy.log"
    log_path var/"log/caddy.log"
    environment_variables(
      XDG_DATA_HOME: "#{HOMEBREW_PREFIX}/var/lib",
      HOME:          "#{HOMEBREW_PREFIX}/var/lib",
    )
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end