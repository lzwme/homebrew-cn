class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https:www.wildfly.org"
  url "https:github.comwildflywildflyreleasesdownload35.0.1.Finalwildfly-35.0.1.Final.tar.gz"
  sha256 "45444ac28f33ee17101cf80b9eff7994f6fd0f2c8fbb4749627d9cec1cbdbc2e"
  license "Apache-2.0"

  livecheck do
    url "https:www.wildfly.orgdownloads"
    regex(href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "cfabdb1ace8a1b6622d062e99999d60561d613840e175f7e8941ecde7374300f"
    sha256 cellar: :any, arm64_sonoma:  "cfabdb1ace8a1b6622d062e99999d60561d613840e175f7e8941ecde7374300f"
    sha256 cellar: :any, arm64_ventura: "cfabdb1ace8a1b6622d062e99999d60561d613840e175f7e8941ecde7374300f"
    sha256 cellar: :any, sonoma:        "afcd4c3a1465274e945bd884bfa4c5e00207eeafe3be66ed52152cc218b141df"
    sha256 cellar: :any, ventura:       "afcd4c3a1465274e945bd884bfa4c5e00207eeafe3be66ed52152cc218b141df"
  end

  # Installs a pre-built `libartemis-native-64.so` file with linkage to libaio.so.1
  depends_on :macos
  depends_on "openjdk"

  def install
    buildpath.glob("bin*.{bat,ps1}").map(&:unlink)
    buildpath.glob("**win-x86_64").map(&:rmtree)
    buildpath.glob("**linux-i686").map(&:rmtree)
    buildpath.glob("**linux-s390x").map(&:rmtree)
    buildpath.glob("**linux-x86_64").map(&:rmtree)
    buildpath.glob("**netty-transport-native-epoll**native").map(&:rmtree)
    if Hardware::CPU.intel?
      buildpath.glob("***_aarch_64.jnilib").map(&:unlink)
    else
      buildpath.glob("**macosx-x86_64").map(&:rmtree)
      buildpath.glob("***_x86_64.jnilib").map(&:unlink)
    end

    inreplace "binstandalone.sh", JAVA="[^"]*", "JAVA='#{Formula["openjdk"].opt_bin}java'"

    libexec.install Dir["*"]
    mkdir_p libexec"standalonelog"
  end

  def caveats
    <<~EOS
      The home of WildFly Application Server #{version} is:
        #{opt_libexec}
      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{opt_libexec}
        export PATH=${PATH}:${JBOSS_HOME}bin
    EOS
  end

  service do
    run [opt_libexec"binstandalone.sh", "--server-config=standalone.xml"]
    environment_variables JBOSS_HOME: opt_libexec, WILDFLY_HOME: opt_libexec
    keep_alive successful_exit: false, crashed: true
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    ENV["JBOSS_LOG_DIR"] = testpath

    port = free_port

    pidfile = testpath"pidfile"
    ENV["LAUNCH_JBOSS_IN_BACKGROUND"] = "true"
    ENV["JBOSS_PIDFILE"] = pidfile

    mkdir testpath"standalone"
    mkdir testpath"standalonedeployments"
    cp_r libexec"standaloneconfiguration", testpath"standalone"
    fork do
      exec opt_libexec"binstandalone.sh", "--server-config=standalone.xml",
                                            "-Djboss.http.port=#{port}",
                                            "-Djboss.server.base.dir=#{testpath}standalone"
    end
    sleep 10
    sleep 10 if Hardware::CPU.intel?

    begin
      system "curl", "-X", "GET", "localhost:#{port}"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end