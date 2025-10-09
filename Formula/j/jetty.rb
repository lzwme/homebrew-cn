class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-home/12.1.2/jetty-home-12.1.2.tar.gz"
  sha256 "1ad684217a8e4aeb60ad2249ffea05b8649eef2f289955fbb0181c1b7189cefb"
  license any_of: ["Apache-2.0", "EPL-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-home/maven-metadata.xml"
    regex(%r{<version>(\d+\.\d+\.\d+)(?!\.[a-zA-Z])</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba8092c9c21182c13964279a5fa7f65740d3b22c82697f432993845925a49a8f"
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