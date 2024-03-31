class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https:www.selenium.dev"
  url "https:github.comSeleniumHQseleniumreleasesdownloadselenium-4.19.0selenium-server-4.19.1.jar"
  sha256 "39349a866531c435fba31f8c3a37aeac814e08baf3ac14e102379568fcf70a7e"
  license "Apache-2.0"

  livecheck do
    url "https:www.selenium.devdownloads"
    regex(href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jari)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6565e40e1ac537621540bc2dd67015f74168f326eb9c37620bb5e1b0e96a04ca"
  end

  depends_on "openjdk"

  def install
    libexec.install "selenium-server-#{version}.jar"
    bin.write_jar_script libexec"selenium-server-#{version}.jar", "selenium-server"
  end

  service do
    run [opt_bin"selenium-server", "standalone", "--port", "4444"]
    keep_alive false
    log_path var"logselenium-output.log"
    error_log_path var"logselenium-error.log"
  end

  test do
    port = free_port
    fork { exec "#{bin}selenium-server standalone --selenium-manager true --port #{port}" }

    parsed_output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--silent", "localhost:#{port}status")
      next unless $CHILD_STATUS.exitstatus.zero?

      parsed_output = JSON.parse(output)
      break if parsed_output["value"]["ready"]
    end

    assert !parsed_output.nil?
    assert parsed_output["value"]["ready"]
    assert_match version.to_s, parsed_output["value"]["nodes"].first["version"]
  end
end