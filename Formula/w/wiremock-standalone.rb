class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.8.0/wiremock-standalone-3.8.0.jar"
  sha256 "704b1adb183c6436f9fcb40ee468fe2c2b95d7c0fe2db10aee7ac64fe726d79f"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0002c833486f0cada5db095a4496405c25432c2a06e7516bd3d79755d7db6fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0002c833486f0cada5db095a4496405c25432c2a06e7516bd3d79755d7db6fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0002c833486f0cada5db095a4496405c25432c2a06e7516bd3d79755d7db6fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0002c833486f0cada5db095a4496405c25432c2a06e7516bd3d79755d7db6fa"
    sha256 cellar: :any_skip_relocation, ventura:        "a0002c833486f0cada5db095a4496405c25432c2a06e7516bd3d79755d7db6fa"
    sha256 cellar: :any_skip_relocation, monterey:       "a0002c833486f0cada5db095a4496405c25432c2a06e7516bd3d79755d7db6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0f377a6fcb578a5bdf29de7df224a143d5821cca20b74c6ac107efe29d40583"
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