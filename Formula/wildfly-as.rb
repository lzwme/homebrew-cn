class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://ghproxy.com/https://github.com/wildfly/wildfly/releases/download/27.0.1.Final/wildfly-27.0.1.Final.tar.gz"
  sha256 "c72892c996b05bfa78c6c632f1a5d4680523d3efb4c0321fa8485f052e15fba9"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "bacff9366a013036e47f094f94efd8c6993ba5548855bf136f97d0aa16bf2164"
    sha256 cellar: :any, arm64_monterey: "bacff9366a013036e47f094f94efd8c6993ba5548855bf136f97d0aa16bf2164"
    sha256 cellar: :any, arm64_big_sur:  "bacff9366a013036e47f094f94efd8c6993ba5548855bf136f97d0aa16bf2164"
    sha256 cellar: :any, ventura:        "33c281724887da7773db8819c3aecaa09c58084863cb07ccc3c29ed0a14d5548"
    sha256 cellar: :any, monterey:       "33c281724887da7773db8819c3aecaa09c58084863cb07ccc3c29ed0a14d5548"
    sha256 cellar: :any, big_sur:        "33c281724887da7773db8819c3aecaa09c58084863cb07ccc3c29ed0a14d5548"
  end

  # Installs a pre-built `libartemis-native-64.so` file with linkage to libaio.so.1
  depends_on :macos
  depends_on "openjdk"

  def install
    buildpath.glob("bin/*.{bat,ps1}").map(&:unlink)
    buildpath.glob("**/win-x86_64").map(&:rmtree)
    buildpath.glob("**/linux-i686").map(&:rmtree)
    buildpath.glob("**/linux-s390x").map(&:rmtree)
    buildpath.glob("**/linux-x86_64").map(&:rmtree)
    buildpath.glob("**/netty-transport-native-epoll/**/native").map(&:rmtree)
    if Hardware::CPU.intel?
      buildpath.glob("**/*_aarch_64.jnilib").map(&:unlink)
    else
      buildpath.glob("**/macosx-x86_64").map(&:rmtree)
      buildpath.glob("**/*_x86_64.jnilib").map(&:unlink)
    end

    inreplace "bin/standalone.sh", /JAVA="[^"]*"/, "JAVA='#{Formula["openjdk"].opt_bin}/java'"

    libexec.install Dir["*"]
    mkdir_p libexec/"standalone/log"
  end

  def caveats
    <<~EOS
      The home of WildFly Application Server #{version} is:
        #{opt_libexec}
      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{opt_libexec}
        export PATH=${PATH}:${JBOSS_HOME}/bin
    EOS
  end

  service do
    run [opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml"]
    environment_variables JBOSS_HOME: opt_libexec, WILDFLY_HOME: opt_libexec
    keep_alive successful_exit: false, crashed: true
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    system "#{opt_libexec}/bin/standalone.sh --version | grep #{version}"

    port = free_port

    pidfile = testpath/"pidfile"
    ENV["LAUNCH_JBOSS_IN_BACKGROUND"] = "true"
    ENV["JBOSS_PIDFILE"] = pidfile

    mkdir testpath/"standalone"
    mkdir testpath/"standalone/deployments"
    cp_r libexec/"standalone/configuration", testpath/"standalone"
    fork do
      exec opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml",
                                            "-Djboss.http.port=#{port}",
                                            "-Djboss.server.base.dir=#{testpath}/standalone"
    end
    sleep 10

    begin
      system "curl", "-X", "GET", "localhost:#{port}/"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end