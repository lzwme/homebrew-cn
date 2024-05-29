class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https:www.jenkins.io"
  url "https:get.jenkins.iowar2.460jenkins.war"
  sha256 "019bd48783af961a129d2a9a89808e5e8eac59fc02c7ca2effc9c987385c7cc4"
  license "MIT"

  livecheck do
    url "https:www.jenkins.iodownload"
    regex(%r{href=.*?warv?(\d+(?:\.\d+)+)jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c58c0e64b85bfde92ce675021e844876a8f1108e41e161a0d7b71d7270bbe3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c58c0e64b85bfde92ce675021e844876a8f1108e41e161a0d7b71d7270bbe3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c58c0e64b85bfde92ce675021e844876a8f1108e41e161a0d7b71d7270bbe3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c58c0e64b85bfde92ce675021e844876a8f1108e41e161a0d7b71d7270bbe3a"
    sha256 cellar: :any_skip_relocation, ventura:        "8c58c0e64b85bfde92ce675021e844876a8f1108e41e161a0d7b71d7270bbe3a"
    sha256 cellar: :any_skip_relocation, monterey:       "8c58c0e64b85bfde92ce675021e844876a8f1108e41e161a0d7b71d7270bbe3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a935d150d83364e2c55583f2dd127e79728ccfba31fab5bfb501b82ee58f464c"
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