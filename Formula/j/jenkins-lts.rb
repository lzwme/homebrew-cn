class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.414.3/jenkins.war"
  sha256 "2d93254bc186df349bc4ad06b6b1dd757c493190f0558d111dbda9517a847b59"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74648658539489db7e671464c4cbe7af8b71f6df8fa6d68f6abd707d7ad77a30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74648658539489db7e671464c4cbe7af8b71f6df8fa6d68f6abd707d7ad77a30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74648658539489db7e671464c4cbe7af8b71f6df8fa6d68f6abd707d7ad77a30"
    sha256 cellar: :any_skip_relocation, sonoma:         "74648658539489db7e671464c4cbe7af8b71f6df8fa6d68f6abd707d7ad77a30"
    sha256 cellar: :any_skip_relocation, ventura:        "74648658539489db7e671464c4cbe7af8b71f6df8fa6d68f6abd707d7ad77a30"
    sha256 cellar: :any_skip_relocation, monterey:       "74648658539489db7e671464c4cbe7af8b71f6df8fa6d68f6abd707d7ad77a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d923543279ca1b7a192339f585b8e6852e4023781cb24dc57cbfa2eb638624bb"
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