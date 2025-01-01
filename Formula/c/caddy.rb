class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https:caddyserver.com"
  url "https:github.comcaddyservercaddyarchiverefstagsv2.9.0.tar.gz"
  sha256 "955c840f3e5981d9b30e48f818d1f42f5f4765a13b3ec658e210d268b93a7cde"
  license "Apache-2.0"
  head "https:github.comcaddyservercaddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e121cf9d994c57a4bb0924e059f9e388e386c44b8feb2fc799369ca53843755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e121cf9d994c57a4bb0924e059f9e388e386c44b8feb2fc799369ca53843755"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e121cf9d994c57a4bb0924e059f9e388e386c44b8feb2fc799369ca53843755"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a9c5033e7e6a0534d6e41faaab6addce0490a001e38e573f7189db787abc4ba"
    sha256 cellar: :any_skip_relocation, ventura:       "0a9c5033e7e6a0534d6e41faaab6addce0490a001e38e573f7189db787abc4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4677059cad1e3a8790fb10e2ad475b2b9ad48360a967eb2eccdb2af80438e826"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https:github.comcaddyserverxcaddyarchiverefstagsv0.4.4.tar.gz"
    sha256 "5ba32eec2388638cebbe1df861ea223c35074528af6a0424f07e436f07adce72"
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