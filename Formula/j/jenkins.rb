class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.425/jenkins.war"
  sha256 "5f338373e018e08032b97db2dfedc365e6dc35bd98aeacf00d73dc141c5a75af"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7e612240652fd5863d0dd8d0f5153d58eee247a37d205e07bff7fa83e6241f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7e612240652fd5863d0dd8d0f5153d58eee247a37d205e07bff7fa83e6241f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7e612240652fd5863d0dd8d0f5153d58eee247a37d205e07bff7fa83e6241f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7e612240652fd5863d0dd8d0f5153d58eee247a37d205e07bff7fa83e6241f1"
    sha256 cellar: :any_skip_relocation, ventura:        "b7e612240652fd5863d0dd8d0f5153d58eee247a37d205e07bff7fa83e6241f1"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e612240652fd5863d0dd8d0f5153d58eee247a37d205e07bff7fa83e6241f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0897a042e656d5586d813d23e6a042803e3a188e49236078bf4f6b00bb8f9e4f"
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