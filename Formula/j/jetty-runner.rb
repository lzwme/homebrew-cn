class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/11.0.25/jetty-runner-11.0.25.jar"
  sha256 "40549bd12c0b8818ad1c93e588d3482f9f110a182405684563f5d4e381958993"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+(?:[._-]v?\d+)?)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15aef216430d1b1c1a0d7823e12102cf7a8d5b1974bb8611ee6bbc3363394844"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"jetty-runner-#{version}.jar", "jetty-runner"
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    touch "#{testpath}/test.war"

    port = free_port
    pid = fork do
      exec "#{bin}/jetty-runner --port #{port} test.war"
    end
    sleep 10

    begin
      output = shell_output("curl -I http://localhost:#{port}")
      assert_match %r{HTTP/1\.1 200 OK}, output
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end