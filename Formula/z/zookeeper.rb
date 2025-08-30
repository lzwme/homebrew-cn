class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.9.4/apache-zookeeper-3.9.4.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.9.4/apache-zookeeper-3.9.4.tar.gz"
  sha256 "b84d0847d5b56c984fe3e50fdd28702340e66db5fd00701fa553d9899b09cabe"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/zookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30629ea6bd355a58883b9c2ddcdc668f69182d52c3bb774ccf6c4e75688655d7"
    sha256 cellar: :any,                 arm64_sonoma:  "e5809bf957d3ecec8a72e0a04c40cd4f34b2c975ed3381458d3b86871534675c"
    sha256 cellar: :any,                 arm64_ventura: "5ba8b90990e86cf729f8bef03183669f27f9552d94d3dae476885dfabd6bc5f2"
    sha256 cellar: :any,                 sonoma:        "b368084f2a77fd9c80ebeec0aad7d1b06dced3786277645dffa886adaf44b67b"
    sha256 cellar: :any,                 ventura:       "199fff017e82f333837bf56be5b4cc9fb2ea160c2345faa45dd83f5a783e2f52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40165048822d3639182b202d18b054c354b4c44604a37d613706f1af322a2d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca9ec36841d6380a78c00a666711f4ae3814f786dcf9d613722e1061866d343"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkgconf" => :build

  depends_on "openjdk"
  depends_on "openssl@3"

  resource "default_logback_xml" do
    url "https://ghfast.top/https://raw.githubusercontent.com/apache/zookeeper/release-3.9.4/conf/logback.xml"
    sha256 "2fae7f51e4f92e8e3536e5f9ac193cb0f4237d194b982bb00b5c8644389c901f"
  end

  def default_zk_env
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def install
    if build.stable? && version != resource("default_logback_xml").version
      odie "default_logback_xml resource needs to be updated"
    end

    system "mvn", "install", "-Pfull-build", "-DskipTests"

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-bin.tar.gz"
    binpfx = "apache-zookeeper-#{version}-bin"
    libexec.install binpfx+"/bin", binpfx+"/lib", "zookeeper-contrib"
    rm(Dir["build-bin/bin/*.cmd"])

    system "tar", "-xf", "zookeeper-assembly/target/apache-zookeeper-#{version}-lib.tar.gz"
    libpfx = "apache-zookeeper-#{version}-lib"
    include.install Dir[libpfx+"/usr/include/*"]
    lib.install Dir[libpfx+"/usr/lib/*"]

    bin.mkpath
    (etc/"zookeeper").mkpath
    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    Pathname.glob("#{libexec}/bin/*.sh") do |path|
      next if path == libexec/"bin/zkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin+bin_name).write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        . "#{etc}/zookeeper/defaults"
        exec "#{libexec}/bin/#{script_name}" "$@"
      EOS
    end

    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    inreplace "conf/zoo.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    (etc/"zookeeper").install "conf/zoo.cfg"

    (pkgshare/"examples").install "conf/logback.xml", "conf/zoo_sample.cfg"
  end

  def post_install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("default_logback_xml")

    defaults = etc/"zookeeper/defaults"
    defaults.write(default_zk_env) unless defaults.exist?

    logback_xml = etc/"zookeeper/logback.xml"
    logback_xml.write(tmpdir/"default_logback_xml") unless logback_xml.exist?
  end

  service do
    run [opt_bin/"zkServer", "start-foreground"]
    environment_variables SERVER_JVMFLAGS: "-Dapple.awt.UIElement=true"
    keep_alive successful_exit: false
    working_dir var
  end

  test do
    output = shell_output("#{bin}/zkServer -h 2>&1")
    assert_match "Using config: #{etc}/zookeeper/zoo.cfg", output
  end
end