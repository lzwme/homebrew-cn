class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.433/jenkins.war"
  sha256 "c392a8cac764164e1784c40b4444c523bd948d42f57abac882ebfa7bf8813887"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c19f9049bd7745a737f38ff181ac8d9d72793daf6d8a78651a4d9324a198cd1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c19f9049bd7745a737f38ff181ac8d9d72793daf6d8a78651a4d9324a198cd1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19f9049bd7745a737f38ff181ac8d9d72793daf6d8a78651a4d9324a198cd1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c19f9049bd7745a737f38ff181ac8d9d72793daf6d8a78651a4d9324a198cd1f"
    sha256 cellar: :any_skip_relocation, ventura:        "c19f9049bd7745a737f38ff181ac8d9d72793daf6d8a78651a4d9324a198cd1f"
    sha256 cellar: :any_skip_relocation, monterey:       "c19f9049bd7745a737f38ff181ac8d9d72793daf6d8a78651a4d9324a198cd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e9131a718fe8e81b08454e19edd24be10a4badb544ab2a24655b5edf114a55e"
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