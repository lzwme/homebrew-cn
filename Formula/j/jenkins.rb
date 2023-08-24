class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.420/jenkins.war"
  sha256 "c9e0778a6eb54e652658ee757848d792bfbd702f7af14a8c2e05978155facc62"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed3f6f1f0c52b724c8e2c2ca10c1b1b63a3f37c33ce2bab65c5850bbc027b68f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed3f6f1f0c52b724c8e2c2ca10c1b1b63a3f37c33ce2bab65c5850bbc027b68f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed3f6f1f0c52b724c8e2c2ca10c1b1b63a3f37c33ce2bab65c5850bbc027b68f"
    sha256 cellar: :any_skip_relocation, ventura:        "ed3f6f1f0c52b724c8e2c2ca10c1b1b63a3f37c33ce2bab65c5850bbc027b68f"
    sha256 cellar: :any_skip_relocation, monterey:       "ed3f6f1f0c52b724c8e2c2ca10c1b1b63a3f37c33ce2bab65c5850bbc027b68f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed3f6f1f0c52b724c8e2c2ca10c1b1b63a3f37c33ce2bab65c5850bbc027b68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123962831ebecf275eb2a33a46889450d3d16017a8a21e87195a6dbef31e9d31"
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