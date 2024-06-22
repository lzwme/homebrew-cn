class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https:www.selenium.dev"
  url "https:github.comSeleniumHQseleniumreleasesdownloadselenium-4.22.0selenium-server-4.22.0.jar"
  sha256 "fb8a6a8c08fcdc0f8134235d3204e5df1b3ab17eeedea3126766759619e98ae8"
  license "Apache-2.0"

  livecheck do
    url "https:www.selenium.devdownloads"
    regex(href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jari)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c1824c6de86ef1868bcc790c188bc4d75d5a7b5432aa9422f32c333894781af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c1824c6de86ef1868bcc790c188bc4d75d5a7b5432aa9422f32c333894781af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c1824c6de86ef1868bcc790c188bc4d75d5a7b5432aa9422f32c333894781af"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c1824c6de86ef1868bcc790c188bc4d75d5a7b5432aa9422f32c333894781af"
    sha256 cellar: :any_skip_relocation, ventura:        "4c1824c6de86ef1868bcc790c188bc4d75d5a7b5432aa9422f32c333894781af"
    sha256 cellar: :any_skip_relocation, monterey:       "4c1824c6de86ef1868bcc790c188bc4d75d5a7b5432aa9422f32c333894781af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca34fb3b68b2f5a77c6e4b15204cb1106f792d813ea2fdc272536883c76ff5b4"
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