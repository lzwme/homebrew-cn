class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.387.3/jenkins.war"
  sha256 "f40374910de94c9c1aafbd0fd190156e7f6afad6dc1534e1b55d20e125156be5"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "220152f565d7a1601bf77b1bd3c642815d5dd846c9dc533eae0866157eca58d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "220152f565d7a1601bf77b1bd3c642815d5dd846c9dc533eae0866157eca58d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "220152f565d7a1601bf77b1bd3c642815d5dd846c9dc533eae0866157eca58d9"
    sha256 cellar: :any_skip_relocation, ventura:        "220152f565d7a1601bf77b1bd3c642815d5dd846c9dc533eae0866157eca58d9"
    sha256 cellar: :any_skip_relocation, monterey:       "220152f565d7a1601bf77b1bd3c642815d5dd846c9dc533eae0866157eca58d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "220152f565d7a1601bf77b1bd3c642815d5dd846c9dc533eae0866157eca58d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82261f56d53898fa05ab0f546552df8992a2e8d8a8c4db9124129bfb0fdc4958"
  end

  depends_on "openjdk@17"

  def install
    system "#{Formula["openjdk@17"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", java_version: "17"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", java_version: "17"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@17"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
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