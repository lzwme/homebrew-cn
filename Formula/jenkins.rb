class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.411/jenkins.war"
  sha256 "e67fb5670069ac6a48822bbf0b01317044f745ce05d2cb03d48825ee4c4e9160"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04f6aa16a77c23a36de37df261ab72cad2bcf9e871299540750e1fdfc2c0699b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04f6aa16a77c23a36de37df261ab72cad2bcf9e871299540750e1fdfc2c0699b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04f6aa16a77c23a36de37df261ab72cad2bcf9e871299540750e1fdfc2c0699b"
    sha256 cellar: :any_skip_relocation, ventura:        "04f6aa16a77c23a36de37df261ab72cad2bcf9e871299540750e1fdfc2c0699b"
    sha256 cellar: :any_skip_relocation, monterey:       "04f6aa16a77c23a36de37df261ab72cad2bcf9e871299540750e1fdfc2c0699b"
    sha256 cellar: :any_skip_relocation, big_sur:        "04f6aa16a77c23a36de37df261ab72cad2bcf9e871299540750e1fdfc2c0699b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "685309ba216c72514d3e77874009506f0fd8f7c6d6419d418e3ffd8e3ae78a5d"
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