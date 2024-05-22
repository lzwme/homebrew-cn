class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https:www.jenkins.io"
  url "https:get.jenkins.iowar2.459jenkins.war"
  sha256 "38fba7e40fc9cc2122efe54e9218a96c67483b4584b1c060017071efe0e118aa"
  license "MIT"

  livecheck do
    url "https:www.jenkins.iodownload"
    regex(%r{href=.*?warv?(\d+(?:\.\d+)+)jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b84a85eb26907d5d6dad55193c898db7628ba41a2e8d9b98776c8d8ec7c430f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a5b80742d37618e304f9c6fa044722dc465a93d3fd68b1a16ef07056eb1de30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baee34bb4075cfd55fc4159056a9ca5d6ca0d0203df338469385bd439a304b4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "38c3cb340546c435cee9ed5901a61ab94c6e00843ddf86dd6a36b4c81ce34394"
    sha256 cellar: :any_skip_relocation, ventura:        "8a67f2ca8f622a3f9a3a1f6a9ebe7b5732635119dc4d6f9ff27318c463ddb71e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e55d5421f292e1bb66357af08a2db3b1379c0049c5afc690793602dbc56cbd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed674505f613b6b5dd8508b2a589692ef90922fc7c7dd027e5644479c6f646d6"
  end

  head do
    url "https:github.comjenkinscijenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk"].opt_bin}jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**jenkins.war", "**cli-#{version}.jar"]
    bin.write_jar_script libexec"jenkins.war", "jenkins"
    bin.write_jar_script libexec"cli-#{version}.jar", "jenkins-cli"

    (var"logjenkins").mkpath
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [opt_bin"jenkins", "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
    keep_alive true
    log_path var"logjenkinsoutput.log"
    error_log_path var"logjenkinserror.log"
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}jenkins --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}")
    assert_match(Welcome to Jenkins!|Unlock Jenkins|Authentication required, output)
  end
end