class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://ghfast.top/https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.36.0/selenium-server-4.36.0.jar"
  sha256 "e4ace22a0355e89f6d06ecd4ba088f07510e1aa2f82ce0911d2d9477846c27c6"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a593ceb6e4f61a5b100b0ed70b8114f0ff42b0463fa8f703383b675fdcdd5e9"
  end

  depends_on "openjdk"

  on_linux do
    depends_on arch: :x86_64 # org.openqa.selenium.grid.config.ConfigException: No drivers for arm64 Linux
  end

  def install
    libexec.install "selenium-server-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-#{version}.jar", "selenium-server"
  end

  service do
    run [opt_bin/"selenium-server", "standalone", "--port", "4444"]
    keep_alive false
    log_path var/"log/selenium-output.log"
    error_log_path var/"log/selenium-error.log"
  end

  test do
    port = free_port
    spawn "#{bin}/selenium-server standalone --selenium-manager true --port #{port}"

    parsed_output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--silent", "localhost:#{port}/status")
      next unless $CHILD_STATUS.exitstatus.zero?

      parsed_output = JSON.parse(output)
      break if parsed_output["value"]["ready"]
    end

    refute_nil parsed_output
    assert parsed_output["value"]["ready"]
    assert_match version.to_s, parsed_output["value"]["nodes"].first["version"]
  end
end