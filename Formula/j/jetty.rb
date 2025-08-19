class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-home/12.1.0/jetty-home-12.1.0.tar.gz"
  sha256 "c154adbac11446368162887fdfbbceecfbdd3455eb9fbacb71c721586633cfef"
  license any_of: ["Apache-2.0", "EPL-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-home/maven-metadata.xml"
    regex(%r{<version>(\d+\.\d+\.\d+)(?!\.[a-zA-Z])</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4e1ed2ef6ba4ea4314ca6de122770ed52cccc78620d35d9d2ceb32adb1fc2cf"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (libexec/"logs").mkpath

    (bin/"jetty").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      export JETTY_HOME="#{libexec}"
      exec "${JAVA_HOME}/bin/java" -jar "${JETTY_HOME}/start.jar" "$@"
    EOS
  end

  test do
    http_port = free_port
    ENV["JETTY_ARGS"] = "jetty.http.port=#{http_port} jetty.ssl.port=#{free_port}"
    ENV["JETTY_BASE"] = testpath
    ENV["JETTY_RUN"] = testpath

    log = testpath/"jetty.log"

    # Add the `demos` module to the "JETTY_BASE" (testpath) for testing.
    system "#{bin}/jetty --add-module=demos > #{log} 2>&1"
    assert_match "Base directory was modified", log.read

    pid = fork do
      $stdout.reopen(log, "a")
      $stderr.reopen(log, "a")
      exec bin/"jetty", *ENV["JETTY_ARGS"].split
    end

    begin
      sleep 20 # grace time for server start
      assert_match "webapp is deployed. DO NOT USE IN PRODUCTION!", log.read
      assert_match "Welcome to Jetty #{version.major}", shell_output("curl --silent localhost:#{http_port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end