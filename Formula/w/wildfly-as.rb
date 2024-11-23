class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https:www.wildfly.org"
  url "https:github.comwildflywildflyreleasesdownload34.0.1.Finalwildfly-34.0.1.Final.tar.gz"
  sha256 "696a39f46c02ce428b9ceb699260d360514f7e6a920e80ed33e4390bf27d0d2a"
  license "Apache-2.0"

  livecheck do
    url "https:www.wildfly.orgdownloads"
    regex(href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fb742b6730c8fd10510c261dd0afd6906eb386d073cc4f562a1d3f943e492714"
    sha256 cellar: :any, arm64_sonoma:  "fb742b6730c8fd10510c261dd0afd6906eb386d073cc4f562a1d3f943e492714"
    sha256 cellar: :any, arm64_ventura: "fb742b6730c8fd10510c261dd0afd6906eb386d073cc4f562a1d3f943e492714"
    sha256 cellar: :any, sonoma:        "dbc859c263edbbd806c03fdb0d5f01107c2cdd924fba16a2c3e0491b7d7ba530"
    sha256 cellar: :any, ventura:       "dbc859c263edbbd806c03fdb0d5f01107c2cdd924fba16a2c3e0491b7d7ba530"
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

    begin
      system "curl", "-X", "GET", "localhost:#{port}"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end