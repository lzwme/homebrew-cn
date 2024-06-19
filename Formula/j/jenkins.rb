class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https:www.jenkins.io"
  url "https:get.jenkins.iowar2.463jenkins.war"
  sha256 "c98b547394334a191a59cd527b884036bc6aee888eb7dec66856a19ecac8f7c9"
  license "MIT"

  livecheck do
    url "https:www.jenkins.iodownload"
    regex(%r{href=.*?warv?(\d+(?:\.\d+)+)jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a738674b29c2f69418f8d2ab327329714a8d24173544406439e7852e9589e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a738674b29c2f69418f8d2ab327329714a8d24173544406439e7852e9589e32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a738674b29c2f69418f8d2ab327329714a8d24173544406439e7852e9589e32"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa48091c8b258a48f0a3f72d280fe2518140483c7ca55a09163a96c1712a8ae9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa48091c8b258a48f0a3f72d280fe2518140483c7ca55a09163a96c1712a8ae9"
    sha256 cellar: :any_skip_relocation, monterey:       "1a738674b29c2f69418f8d2ab327329714a8d24173544406439e7852e9589e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fe27eada9b7a66c82ca1ffe5888bdf4f2f4c9e0e19b3c26c3e59d0608f08a9b"
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