class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.400/jenkins.war"
  sha256 "d22016eff561dbaff469ab1dbf3b437f4d89e6543f3d1c1283bc91b46b74656e"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7297a8ee8bd6ff15751d28b36553ae52744e5d959030feef649fa9063c0d66f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7297a8ee8bd6ff15751d28b36553ae52744e5d959030feef649fa9063c0d66f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7297a8ee8bd6ff15751d28b36553ae52744e5d959030feef649fa9063c0d66f1"
    sha256 cellar: :any_skip_relocation, ventura:        "7297a8ee8bd6ff15751d28b36553ae52744e5d959030feef649fa9063c0d66f1"
    sha256 cellar: :any_skip_relocation, monterey:       "7297a8ee8bd6ff15751d28b36553ae52744e5d959030feef649fa9063c0d66f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7297a8ee8bd6ff15751d28b36553ae52744e5d959030feef649fa9063c0d66f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76435bd3477e4310ffdfe56b9853fb471474475ebe0029e45485214fd4bf5a19"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk@17"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk@17"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins", java_version: "17"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli", java_version: "17"

    (var/"log/jenkins").mkpath
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [opt_bin/"jenkins", "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
    keep_alive true
    log_path var/"log/jenkins/output.log"
    error_log_path var/"log/jenkins/error.log"
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end