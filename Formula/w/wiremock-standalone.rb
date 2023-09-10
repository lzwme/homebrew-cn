class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.0.4/wiremock-standalone-3.0.4.jar"
  sha256 "cb34340947d142e8f11fb16530f10030e0a322acb6acd531c2f004b90c0f2254"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4defdea3724d4e6ab337f006774bee908c35e880b035ac1b6410e525d0d77304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4defdea3724d4e6ab337f006774bee908c35e880b035ac1b6410e525d0d77304"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4defdea3724d4e6ab337f006774bee908c35e880b035ac1b6410e525d0d77304"
    sha256 cellar: :any_skip_relocation, ventura:        "4defdea3724d4e6ab337f006774bee908c35e880b035ac1b6410e525d0d77304"
    sha256 cellar: :any_skip_relocation, monterey:       "4defdea3724d4e6ab337f006774bee908c35e880b035ac1b6410e525d0d77304"
    sha256 cellar: :any_skip_relocation, big_sur:        "4defdea3724d4e6ab337f006774bee908c35e880b035ac1b6410e525d0d77304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85682df733283292ac8356b0c5a429801fa432d4a717f8476659507d509c6be"
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