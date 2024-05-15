class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https:www.jenkins.io"
  url "https:get.jenkins.iowar2.458jenkins.war"
  sha256 "236b5902266c1c9e42e83bc7bed39ec03cd3cc5bfcaa0f88eff3cfc955b43232"
  license "MIT"

  livecheck do
    url "https:www.jenkins.iodownload"
    regex(%r{href=.*?warv?(\d+(?:\.\d+)+)jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49e092149fa4ee282ebdc5631ad33b25fd105ee19830d5322f768ab5cddec58f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0098d651d528fbe3b06ed9a743ba918f566bfc78f12b1bbad2e4a671d4a722f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9110eca971538add8d5c49f2b56bca3c82aabb5ce407373ba4b33baab148037b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f1b58ce378379b65d6048dc915e1114fa5dd90fd79a7ddbb0a955f482947521"
    sha256 cellar: :any_skip_relocation, ventura:        "a82e762fbc4708e0a770b82648d5703d3e2e20c6be02b423352e713843ee45ff"
    sha256 cellar: :any_skip_relocation, monterey:       "61cea0bdf7197c623461beac348bb3f1ac65bdaadcaf859108e7f047a37f7c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3041af9bba473f2d2f491634b29f1526bc908dda9ae0410d7dfd5c50e9e007f"
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