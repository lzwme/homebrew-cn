class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https:caddyserver.com"
  url "https:github.comcaddyservercaddyarchiverefstagsv2.8.1.tar.gz"
  sha256 "1efd6aad92210288a89b76c1e639da7ba0009f2ab3ae7c78b5818b67257f732c"
  license "Apache-2.0"
  head "https:github.comcaddyservercaddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42089d87c7b5cc5bbb8c62c28b5d51de68880e529502c771928b7fdcb4c86c5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42089d87c7b5cc5bbb8c62c28b5d51de68880e529502c771928b7fdcb4c86c5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42089d87c7b5cc5bbb8c62c28b5d51de68880e529502c771928b7fdcb4c86c5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "067bc1ef46d5aeb127552c631645e6c5b02f460eb29c0751a2ab93566b858df6"
    sha256 cellar: :any_skip_relocation, ventura:        "067bc1ef46d5aeb127552c631645e6c5b02f460eb29c0751a2ab93566b858df6"
    sha256 cellar: :any_skip_relocation, monterey:       "067bc1ef46d5aeb127552c631645e6c5b02f460eb29c0751a2ab93566b858df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f1d4773fe3391620b9bf3ba495960ef1431cd4370100053313f85860fabc12"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https:github.comcaddyserverxcaddyarchiverefstagsv0.4.2.tar.gz"
    sha256 "02e685227fdddd2756993ca019cbe120da61833df070ccf23f250c122c13d554"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmdxcaddymain.go", "build", revision, "--output", bin"caddy"
    end

    generate_completions_from_executable("go", "run", "cmdcaddymain.go", "completion")

    system bin"caddy", "manpage", "--directory", buildpath"man"

    man8.install Dir[buildpath"man*.8"]
  end

  def caveats
    <<~EOS
      When running the provided service, caddy's data dir will be set as
        `#{HOMEBREW_PREFIX}varlib`
        instead of the default location found at https:caddyserver.comdocsconventions#data-directory
    EOS
  end

  service do
    run [opt_bin"caddy", "run", "--config", etc"Caddyfile"]
    keep_alive true
    error_log_path var"logcaddy.log"
    log_path var"logcaddy.log"
    environment_variables XDG_DATA_HOME: "#{HOMEBREW_PREFIX}varlib"
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http:127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin"caddy", "run", "--config", testpath"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http:127.0.0.1:#{port1}configappshttpserverssrv0listen0")
    assert_match "Hello, Caddy!", shell_output("curl -s http:127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}caddy version")
  end
end