class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.0.3/wiremock-standalone-3.0.3.jar"
  sha256 "4667b72070bbe46e468cf92f0ad0a5a28a249f899be92b2628d3ba6a27e67d32"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f98c022ebeea015ad9119e9c23c9f4e36df3add8741b7c13cdde3d0aa1ad52ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f98c022ebeea015ad9119e9c23c9f4e36df3add8741b7c13cdde3d0aa1ad52ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f98c022ebeea015ad9119e9c23c9f4e36df3add8741b7c13cdde3d0aa1ad52ac"
    sha256 cellar: :any_skip_relocation, ventura:        "f98c022ebeea015ad9119e9c23c9f4e36df3add8741b7c13cdde3d0aa1ad52ac"
    sha256 cellar: :any_skip_relocation, monterey:       "f98c022ebeea015ad9119e9c23c9f4e36df3add8741b7c13cdde3d0aa1ad52ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f98c022ebeea015ad9119e9c23c9f4e36df3add8741b7c13cdde3d0aa1ad52ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "329b7dc029ebfdcce8f39f2472a3b5a87f1d51d43c91cd456fd84a9f2d003850"
  end

  depends_on "openjdk"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-standalone-#{version}.jar", "wiremock"
  end

  test do
    port = free_port

    wiremock = fork do
      exec "#{bin}/wiremock", "-port", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/__admin/", "-X", "GET")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/__admin/shutdown", "-X", "POST"

    Process.wait(wiremock)
  end
end