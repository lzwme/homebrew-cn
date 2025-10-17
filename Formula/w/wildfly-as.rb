class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://ghfast.top/https://github.com/wildfly/wildfly/releases/download/38.0.0.Final/wildfly-38.0.0.Final.tar.gz"
  sha256 "f6dddf4338a6cf872e057dccefbf88285d34a090262eb9b664ce79b13a56c2d0"
  license "Apache-2.0"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c6a6fd5ccbbeefe61cd2f2e8ddf87657e159ad0482ca1dd97e6506ba3e7cc300"
    sha256 cellar: :any, arm64_sequoia: "6d54dd12de1bf7277939e7a21ded5365d77ec08020ec3b0559d8bf58b2a283f0"
    sha256 cellar: :any, arm64_sonoma:  "6d54dd12de1bf7277939e7a21ded5365d77ec08020ec3b0559d8bf58b2a283f0"
    sha256 cellar: :any, sonoma:        "fe3ad0511d3167cbe85a3c519dda2030aa294f2468e062efd901fe05295ae8a5"
  end

  # Installs a pre-built `libartemis-native-64.so` file with linkage to libaio.so.1
  depends_on :macos
  depends_on "openjdk"

  def install
    buildpath.glob("bin/*.{bat,ps1}").map(&:unlink)
    rm_r buildpath.glob("**/win-x86_64")
    rm_r buildpath.glob("**/linux-i686")
    rm_r buildpath.glob("**/linux-s390x")
    rm_r buildpath.glob("**/linux-x86_64")
    rm_r buildpath.glob("**/netty-transport-native-epoll/**/native")
    if Hardware::CPU.intel?
      buildpath.glob("**/*_aarch_64.jnilib").map(&:unlink)
    else
      rm_r buildpath.glob("**/macosx-x86_64")
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
    ENV["JBOSS_LOG_DIR"] = testpath

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
    sleep 10 if Hardware::CPU.intel?

    begin
      system "curl", "-X", "GET", "localhost:#{port}/"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end