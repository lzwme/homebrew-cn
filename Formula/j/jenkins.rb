class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.429/jenkins.war"
  sha256 "1dc21a394e6450bae158e5415396b8dc50fb80e60321b8abee5d460b0f214241"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f434c9afe8625e4cd3ddcdbb6f349b37230b1f1301cacd4759ebb175d16f8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f434c9afe8625e4cd3ddcdbb6f349b37230b1f1301cacd4759ebb175d16f8f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f434c9afe8625e4cd3ddcdbb6f349b37230b1f1301cacd4759ebb175d16f8f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f434c9afe8625e4cd3ddcdbb6f349b37230b1f1301cacd4759ebb175d16f8f4"
    sha256 cellar: :any_skip_relocation, ventura:        "6f434c9afe8625e4cd3ddcdbb6f349b37230b1f1301cacd4759ebb175d16f8f4"
    sha256 cellar: :any_skip_relocation, monterey:       "6f434c9afe8625e4cd3ddcdbb6f349b37230b1f1301cacd4759ebb175d16f8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd83cdd10912960fd4bb5f0c147c8ad70b195fc3936775a6eb330585637253a3"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli"

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