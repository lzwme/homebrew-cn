class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.452.3/jenkins.war"
  sha256 "45fd2b877f9709a52b984d9c7d6f435bc05f6adee61291d22d30b5f1e8fd8c59"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bcd6a862bedf76fda734efdda905655b41a46fb1fc173d8f0f433c2234ce46b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bcd6a862bedf76fda734efdda905655b41a46fb1fc173d8f0f433c2234ce46b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bcd6a862bedf76fda734efdda905655b41a46fb1fc173d8f0f433c2234ce46b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bcd6a862bedf76fda734efdda905655b41a46fb1fc173d8f0f433c2234ce46b"
    sha256 cellar: :any_skip_relocation, ventura:        "8bcd6a862bedf76fda734efdda905655b41a46fb1fc173d8f0f433c2234ce46b"
    sha256 cellar: :any_skip_relocation, monterey:       "8bcd6a862bedf76fda734efdda905655b41a46fb1fc173d8f0f433c2234ce46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "491d71a4da02835be0a3b249601c46778c238ecce8ed064b73cd44fd789c1aab"
  end

  depends_on "openjdk@21"

  def install
    system "#{Formula["openjdk@21"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", java_version: "21"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", java_version: "21"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@21"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins-lts --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end