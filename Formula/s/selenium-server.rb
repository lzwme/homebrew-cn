class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https:www.selenium.dev"
  url "https:github.comSeleniumHQseleniumreleasesdownloadselenium-4.15.0selenium-server-4.15.0.jar"
  sha256 "0933b1fc5febce425b0e3f538c9832f43f4e384f69f384d6223d1e9ec9ba597a"
  license "Apache-2.0"

  livecheck do
    url "https:www.selenium.devdownloads"
    regex(href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jari)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, sonoma:         "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, ventura:        "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, monterey:       "068bbd7f8a7deb14348608feb703b372e2d28b196572469090a06617bc0b4cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38ffaaa85b8a3a278f72fcc4b90bc4b6f3e20c7781bba976fcd0f39df4b1e4ac"
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