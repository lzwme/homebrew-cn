class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.9.0/wiremock-standalone-3.9.0.jar"
  sha256 "63b319c9c2b2e0dc641b95bf90f098d51eaf9dfc553c225d1d89f8c89e3b3acf"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66671854085f8ce03e2003896749095dc4062870e5ab2240944cf79e98a39b74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66671854085f8ce03e2003896749095dc4062870e5ab2240944cf79e98a39b74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66671854085f8ce03e2003896749095dc4062870e5ab2240944cf79e98a39b74"
    sha256 cellar: :any_skip_relocation, sonoma:         "66671854085f8ce03e2003896749095dc4062870e5ab2240944cf79e98a39b74"
    sha256 cellar: :any_skip_relocation, ventura:        "66671854085f8ce03e2003896749095dc4062870e5ab2240944cf79e98a39b74"
    sha256 cellar: :any_skip_relocation, monterey:       "66671854085f8ce03e2003896749095dc4062870e5ab2240944cf79e98a39b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "570616cd3f3f75743cae888b016328e709202c63c43a0f2ca05e7cfb0bab69f5"
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