class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https:www.selenium.dev"
  url "https:github.comSeleniumHQseleniumreleasesdownloadselenium-4.23.0selenium-server-4.23.0.jar"
  sha256 "f6a8163dc4d5cb51c7586fba7d948b3567dbbb3717e19aa3ae7b272ae36da2ae"
  license "Apache-2.0"

  livecheck do
    url "https:www.selenium.devdownloads"
    regex(href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jari)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3dd468e945b50fec89ec9001e198ede9f54c4bfc63b8bcb4d8fe30950558d51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3dd468e945b50fec89ec9001e198ede9f54c4bfc63b8bcb4d8fe30950558d51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3dd468e945b50fec89ec9001e198ede9f54c4bfc63b8bcb4d8fe30950558d51"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3dd468e945b50fec89ec9001e198ede9f54c4bfc63b8bcb4d8fe30950558d51"
    sha256 cellar: :any_skip_relocation, ventura:        "b3dd468e945b50fec89ec9001e198ede9f54c4bfc63b8bcb4d8fe30950558d51"
    sha256 cellar: :any_skip_relocation, monterey:       "b3dd468e945b50fec89ec9001e198ede9f54c4bfc63b8bcb4d8fe30950558d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e97208e4a5e0838fedf11c719673c6964254f09541eaf105227f90d1adf016e"
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