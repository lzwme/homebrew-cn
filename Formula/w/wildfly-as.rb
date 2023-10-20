class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://ghproxy.com/https://github.com/wildfly/wildfly/releases/download/30.0.0.Final/wildfly-30.0.0.Final.tar.gz"
  sha256 "e10404c9d3e035a7d364b22b2e343fe8ae867b6bbcbf945bf2a969eff7d9ebea"
  license "Apache-2.0"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6bbea4633eb9c618e5d5fa08d926a9f65000dfcc7323c7ab7de3a110176eed48"
    sha256 cellar: :any, arm64_ventura:  "6bbea4633eb9c618e5d5fa08d926a9f65000dfcc7323c7ab7de3a110176eed48"
    sha256 cellar: :any, arm64_monterey: "6bbea4633eb9c618e5d5fa08d926a9f65000dfcc7323c7ab7de3a110176eed48"
    sha256 cellar: :any, sonoma:         "f9cd88aa5606ec0c0911719149f3e8e92006d67b9026d2c87b5c3a49963db196"
    sha256 cellar: :any, ventura:        "f9cd88aa5606ec0c0911719149f3e8e92006d67b9026d2c87b5c3a49963db196"
    sha256 cellar: :any, monterey:       "f9cd88aa5606ec0c0911719149f3e8e92006d67b9026d2c87b5c3a49963db196"
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