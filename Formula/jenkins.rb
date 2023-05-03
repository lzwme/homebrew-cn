class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.403/jenkins.war"
  sha256 "30df8e6c5f04e89e31d53a48cb9df340c22fd3c54c0f14efc494da95c083ffc7"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5768f0df1980c19cd8d3e58374361dc8db6b11d028df9302538f8bee3d35f0b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5768f0df1980c19cd8d3e58374361dc8db6b11d028df9302538f8bee3d35f0b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5768f0df1980c19cd8d3e58374361dc8db6b11d028df9302538f8bee3d35f0b9"
    sha256 cellar: :any_skip_relocation, ventura:        "5768f0df1980c19cd8d3e58374361dc8db6b11d028df9302538f8bee3d35f0b9"
    sha256 cellar: :any_skip_relocation, monterey:       "5768f0df1980c19cd8d3e58374361dc8db6b11d028df9302538f8bee3d35f0b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5768f0df1980c19cd8d3e58374361dc8db6b11d028df9302538f8bee3d35f0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603d1861a269f06a462a4e967aa849ca73aa66e428b8a484f9c0f7b19e215363"
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