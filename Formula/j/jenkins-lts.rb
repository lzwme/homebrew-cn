class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.452.1/jenkins.war"
  sha256 "d9ec867a35987b545c82ed0df5d2240ac208a8d06e065e9cdb869464f3b87a56"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a89a9f68f8212cbc1b6d86b5eb0412e60ee93652bea97b3cd242fcf346a7a3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20ef70f2b1bd5db0f159a6058d0e6c6a61505009eb7de0e897389d9a25976829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0aa3b911a68d5f107a98e8eacf92b587e9e8c055f034d2bd5f12a42609ab870"
    sha256 cellar: :any_skip_relocation, sonoma:         "9692ec68fb7e82c0a9ef1137edaa112f3833f8fa54952d80f52b72effa307528"
    sha256 cellar: :any_skip_relocation, ventura:        "f49dc2e5ca3a035f7815f7f0d6b31bdd73a099d9779d86797b989816f9212a95"
    sha256 cellar: :any_skip_relocation, monterey:       "acbd548e1084a195358960bd8fe624cdae4b83081c14a4dfa6af3871f717b716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81c55edac7c109800114721b2c1d09d0883baacd29d414fdd1fd9cc56e29ee8"
  end

  depends_on "openjdk"

  def install
    system "#{Formula["openjdk"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins-lts --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end