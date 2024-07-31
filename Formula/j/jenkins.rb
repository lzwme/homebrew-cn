class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https:www.jenkins.io"
  url "https:get.jenkins.iowar2.470jenkins.war"
  sha256 "0143a231fa5a93e77bfd4d1283ae5df825a2d8d19343a400d02284768d56319f"
  license "MIT"

  livecheck do
    url "https:www.jenkins.iodownload"
    regex(%r{href=.*?warv?(\d+(?:\.\d+)+)jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80afd6f874fcad01230c9dfbf463bfad6c1502c22ef29ca29efe4e26775ce040"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80afd6f874fcad01230c9dfbf463bfad6c1502c22ef29ca29efe4e26775ce040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80afd6f874fcad01230c9dfbf463bfad6c1502c22ef29ca29efe4e26775ce040"
    sha256 cellar: :any_skip_relocation, sonoma:         "80afd6f874fcad01230c9dfbf463bfad6c1502c22ef29ca29efe4e26775ce040"
    sha256 cellar: :any_skip_relocation, ventura:        "80afd6f874fcad01230c9dfbf463bfad6c1502c22ef29ca29efe4e26775ce040"
    sha256 cellar: :any_skip_relocation, monterey:       "80afd6f874fcad01230c9dfbf463bfad6c1502c22ef29ca29efe4e26775ce040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1edf4ae28fa23236733ab859cc1a019090fe89885f195ec894cbbc42213778"
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