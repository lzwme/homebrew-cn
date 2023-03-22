class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.396/jenkins.war"
  sha256 "d6cafd9558812f7abf1b3cc5a1c7fa5e91afe148731a5a4b41befa0e23a35e30"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b4437aee0e826aacad8dfeaa14dbd80903bbc4c1d39257bcead9619b440f01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b4437aee0e826aacad8dfeaa14dbd80903bbc4c1d39257bcead9619b440f01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b4437aee0e826aacad8dfeaa14dbd80903bbc4c1d39257bcead9619b440f01"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b4437aee0e826aacad8dfeaa14dbd80903bbc4c1d39257bcead9619b440f01"
    sha256 cellar: :any_skip_relocation, monterey:       "e0b4437aee0e826aacad8dfeaa14dbd80903bbc4c1d39257bcead9619b440f01"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0b4437aee0e826aacad8dfeaa14dbd80903bbc4c1d39257bcead9619b440f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79454ca01a8411c954f5c70bf333498146829b29fd39c42c58d9dda1b168d9c1"
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