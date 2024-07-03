class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https:www.jenkins.io"
  url "https:get.jenkins.iowar2.466jenkins.war"
  sha256 "6334c70dcfb4ef0815387bffb83db4a322c29baee51cd2e90863b061c5b884fc"
  license "MIT"

  livecheck do
    url "https:www.jenkins.iodownload"
    regex(%r{href=.*?warv?(\d+(?:\.\d+)+)jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd24e9f57ea47f13587c177fb85d2b4c2b8c87d31db86768d2376496ce6856df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd24e9f57ea47f13587c177fb85d2b4c2b8c87d31db86768d2376496ce6856df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd24e9f57ea47f13587c177fb85d2b4c2b8c87d31db86768d2376496ce6856df"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd24e9f57ea47f13587c177fb85d2b4c2b8c87d31db86768d2376496ce6856df"
    sha256 cellar: :any_skip_relocation, ventura:        "dd24e9f57ea47f13587c177fb85d2b4c2b8c87d31db86768d2376496ce6856df"
    sha256 cellar: :any_skip_relocation, monterey:       "dd24e9f57ea47f13587c177fb85d2b4c2b8c87d31db86768d2376496ce6856df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0536a0b6d8071b12bd32f57c09fdfd9c3b3799e15197ed49a4827739baff6a3"
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