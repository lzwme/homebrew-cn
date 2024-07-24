class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https:www.jenkins.io"
  url "https:get.jenkins.iowar2.469jenkins.war"
  sha256 "954b2759e2309151596e90bb5a88ddfd950d9397440403641bbefe5c3a2a016e"
  license "MIT"

  livecheck do
    url "https:www.jenkins.iodownload"
    regex(%r{href=.*?warv?(\d+(?:\.\d+)+)jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11abd540d6f30234d0f9de9c63d9b6ed9f56fbefd69700162e560986a67cfb2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11abd540d6f30234d0f9de9c63d9b6ed9f56fbefd69700162e560986a67cfb2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11abd540d6f30234d0f9de9c63d9b6ed9f56fbefd69700162e560986a67cfb2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7660c9b53f732885c37738df503f555d8a0a25b5a77aefc8c8bf7bb9dd04b548"
    sha256 cellar: :any_skip_relocation, ventura:        "7660c9b53f732885c37738df503f555d8a0a25b5a77aefc8c8bf7bb9dd04b548"
    sha256 cellar: :any_skip_relocation, monterey:       "11abd540d6f30234d0f9de9c63d9b6ed9f56fbefd69700162e560986a67cfb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172f05ee2afc37ff4c3d35d9227a8f7cb0f2472a20e4e1be53b30a42915e5ffa"
  end

  head do
    url "https:github.comjenkinscijenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk@21"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk@21"].opt_bin}jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**jenkins.war", "**cli-#{version}.jar"]
    bin.write_jar_script libexec"jenkins.war", "jenkins", java_version: "21"
    bin.write_jar_script libexec"cli-#{version}.jar", "jenkins-cli", java_version: "21"

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