class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.426.1/jenkins.war"
  sha256 "8d84f3cdd6430c098d1f4f38740957e3f2d0ac261b2f9c68cbf9c306363fd1c8"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f60121d461f83dc382519826339ffdd83489f424fadb870036cfaf597f515d2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f60121d461f83dc382519826339ffdd83489f424fadb870036cfaf597f515d2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f60121d461f83dc382519826339ffdd83489f424fadb870036cfaf597f515d2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f60121d461f83dc382519826339ffdd83489f424fadb870036cfaf597f515d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "f60121d461f83dc382519826339ffdd83489f424fadb870036cfaf597f515d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "f60121d461f83dc382519826339ffdd83489f424fadb870036cfaf597f515d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f36da64e359c01b7ae981379b329e88a8fdda649ecd183545d39f9cff5e739c"
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