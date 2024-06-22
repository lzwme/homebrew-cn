class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.7.0/wiremock-standalone-3.7.0.jar"
  sha256 "f273fe42ff90663c86d1571a05ddb650888462c7cfabf0f5ddcf8a4f6ef4d159"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b11648d960823abb58d41fc054c58ab337374bcdaacf54fe62198152f869d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b11648d960823abb58d41fc054c58ab337374bcdaacf54fe62198152f869d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b11648d960823abb58d41fc054c58ab337374bcdaacf54fe62198152f869d2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "65c982ef20d0ac8885b6af3f082aa9b2f4e9390c13925a1114475225488d74cf"
    sha256 cellar: :any_skip_relocation, ventura:        "65c982ef20d0ac8885b6af3f082aa9b2f4e9390c13925a1114475225488d74cf"
    sha256 cellar: :any_skip_relocation, monterey:       "1d41e0c9fcbff3d663f5f2671b33f84a55090983cee40b40e8e588c34058dc86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f604f499d1b5fa849b3c39e27e7bb60b35a3b1a7a824fe071b5f4ab298407464"
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