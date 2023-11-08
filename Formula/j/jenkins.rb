class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.431/jenkins.war"
  sha256 "c0fe49dbd53f7cc52d90810cecdec6ab9b54665f4137977c2e7d7f642145e734"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe0f1cfb28b08b57315ecf331bc3319a7cab5cd66bc8fb7d34377559fe576a0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe0f1cfb28b08b57315ecf331bc3319a7cab5cd66bc8fb7d34377559fe576a0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0f1cfb28b08b57315ecf331bc3319a7cab5cd66bc8fb7d34377559fe576a0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe0f1cfb28b08b57315ecf331bc3319a7cab5cd66bc8fb7d34377559fe576a0a"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0f1cfb28b08b57315ecf331bc3319a7cab5cd66bc8fb7d34377559fe576a0a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe0f1cfb28b08b57315ecf331bc3319a7cab5cd66bc8fb7d34377559fe576a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40be84359f57204f9ed7f0f2a6d8cb23a4ddb5a488ae9da100ac54b66f0cdd20"
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