class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://ghfast.top/https://github.com/caddyserver/caddy/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "cb65c6d2081e2700f44e03d808a0330344b483688934c87e53ba7b5728a3a04b"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b873c00dc3a62cd38c62081cd58736259ff3355868b79351ed70aeb6c50e97f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b873c00dc3a62cd38c62081cd58736259ff3355868b79351ed70aeb6c50e97f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b873c00dc3a62cd38c62081cd58736259ff3355868b79351ed70aeb6c50e97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9adc9e9e5361b8f7befe187a99e1db4a66889263781070a6cff6dd4fe26ecf19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "263507fdd358fab21318e13ee4aaf03148ac76a4a9523830369d5c04c0fa15f2"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://ghfast.top/https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.4.5.tar.gz"
    sha256 "53c6a9e29965aaf19210ac6470935537040e782101057a199098feb33c2674f8"
  end

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    # caddy's own modules, for the `go run cmd/caddy/main.go` completions step
    # and as the dependencies of the tagged caddy module xcaddy builds
    system "go", "mod", "download", "all"
    # the tagged caddy module itself, resolved by xcaddy at build time
    system "go", "mod", "download", "github.com/caddyserver/caddy/v2@v#{version}" unless build.head?
    # xcaddy's own modules
    resource("xcaddy").stage do
      system "go", "mod", "download"
    end
  end

  def install
    # modules were downloaded and sumdb-verified in `fetch`; the temp module
    # xcaddy creates has no go.sum, so serve it from the local cache only
    ENV["GOPROXY"] = "off"
    ENV["GOSUMDB"] = "off"

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