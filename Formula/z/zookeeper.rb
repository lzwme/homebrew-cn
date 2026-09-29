class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.9.6/apache-zookeeper-3.9.6.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.9.6/apache-zookeeper-3.9.6.tar.gz"
  sha256 "9277edd177f795c68b3a92cb411a79076b12ad3184fbf900c0d7cec9a0a52e0a"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "447c4ad9c04cc740775c7f17fa082acfb796f75184bf64c0b7b7510b6a256d1c"
    sha256 cellar: :any, arm64_tahoe:       "01e35c9c5419bf3e424e5e77f716997ee3a70429a0e89c8c9e635533e8eb0836"
    sha256 cellar: :any, arm64_sequoia:     "d5b9541184630771847908f13efa9cfa3555fd2b12391af97a2d0b1f5ec0cd87"
    sha256 cellar: :any, arm64_linux:       "a4469e2e5d9b74b3ceaa804526c95cd2d96956d0a517f17e6685b224394768b5"
    sha256 cellar: :any, x86_64_linux:      "637a632c6293ecfbc7e033583b2b73fa9497fcae439c9bc7714dcd758888a2d4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkgconf" => :build

  depends_on "openjdk"
  depends_on "openssl@4"

  deny_network_access!

  def default_zk_env
    <<~ZSH
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{pkgetc}"
    ZSH
  end

  def fetch
    system "mvn", "dependency:go-offline", "-Pfull-build"
  end

  def install
    system "mvn", "install", "-Pfull-build", "-DskipTests", "-Dc-client-openssl=#{formula_opt_prefix("openssl@4")}"

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-bin.tar.gz"
    binpfx = "apache-zookeeper-#{version}-bin"
    libexec.install binpfx+"/bin", binpfx+"/lib", "zookeeper-contrib"
    rm(Dir["build-bin/bin/*.cmd"])

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-lib.tar.gz"
    libpfx = "apache-zookeeper-#{version}-lib"
    include.install Dir[libpfx+"/usr/include/*"]
    lib.install Dir[libpfx+"/usr/lib/*"]

    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    libexec.glob("bin/*.sh") do |path|
      next if path == libexec/"bin/zkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin/bin_name).write <<~BASH
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{formula_opt_prefix("openjdk")}}"
        . "#{pkgetc}/defaults"
        exec "#{libexec}/bin/#{script_name}" "$@"
      BASH
    end

    (buildpath/"defaults").write(default_zk_env)
    cp "conf/logback.xml", "logback.xml"
    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    inreplace "conf/zoo.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    pkgetc.install "conf/zoo.cfg", "defaults", "logback.xml"
    (pkgshare/"examples").install "conf/logback.xml", "conf/zoo_sample.cfg"
  end

  service do
    run [opt_bin/"zkServer", "start-foreground"]
    environment_variables SERVER_JVMFLAGS: "-Dapple.awt.UIElement=true"
    keep_alive successful_exit: false
    working_dir var
  end

  test do
    output = shell_output("#{bin}/zkServer -h 2>&1")
    assert_match "Using config: #{pkgetc}/zoo.cfg", output
  end
end