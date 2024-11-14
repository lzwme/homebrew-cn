class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https:zookeeper.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=zookeeperzookeeper-3.9.3apache-zookeeper-3.9.3.tar.gz"
  mirror "https:archive.apache.orgdistzookeeperzookeeper-3.9.3apache-zookeeper-3.9.3.tar.gz"
  sha256 "8bf0b9f872b3c0a6e64f8bc55ffb44cbff6e2712f6467ee5164ca6847466b31b"
  license "Apache-2.0"
  head "https:gitbox.apache.orgreposasfzookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55cdbe85faf89339c7388d17582a1c611acf856dbc61b09386f53a4f94e2250d"
    sha256 cellar: :any,                 arm64_sonoma:  "877ea34a0512cef5350a11523bffa1ac380306a1bcdfc444a4b09417e56e4b96"
    sha256 cellar: :any,                 arm64_ventura: "b32a242b6462efee1aeba8315f944328b89b0f027d345c4b19dbb42c7d8e3210"
    sha256 cellar: :any,                 sonoma:        "43493f6555c4c8028c1f46957092b5b9ee99a1a2beae025d23571bff79a6cf5a"
    sha256 cellar: :any,                 ventura:       "aca1f280391c77002a8822e6fc1c8434c5680144d7f536aeae5ff17efd52ff00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c4a13aefe7898e15aa63cb9dd001c673ad8e520128e6816599a6b50f97acb8"
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
    url "https:raw.githubusercontent.comapachezookeeperrelease-3.9.3conflogback.xml"
    sha256 "2fae7f51e4f92e8e3536e5f9ac193cb0f4237d194b982bb00b5c8644389c901f"
  end

  def default_zk_env
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{etc}zookeeper"
    EOS
  end

  def install
    if build.stable? && version != resource("default_logback_xml").version
      odie "default_logback_xml resource needs to be updated"
    end

    system "mvn", "install", "-Pfull-build", "-DskipTests"

    system "tar", "-xf", "zookeeper-assemblytargetapache-zookeeper-#{version}-bin.tar.gz"
    binpfx = "apache-zookeeper-#{version}-bin"
    libexec.install binpfx+"bin", binpfx+"lib", "zookeeper-contrib"
    rm(Dir["build-binbin*.cmd"])

    system "tar", "-xf", "zookeeper-assemblytargetapache-zookeeper-#{version}-lib.tar.gz"
    libpfx = "apache-zookeeper-#{version}-lib"
    include.install Dir[libpfx+"usrinclude*"]
    lib.install Dir[libpfx+"usrlib*"]

    bin.mkpath
    (etc"zookeeper").mkpath
    (var"logzookeeper").mkpath
    (var"runzookeeperdata").mkpath

    Pathname.glob("#{libexec}bin*.sh") do |path|
      next if path == libexec+"binzkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin+bin_name).write <<~EOS
        #!binbash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        . "#{etc}zookeeperdefaults"
        exec "#{libexec}bin#{script_name}" "$@"
      EOS
    end

    cp "confzoo_sample.cfg", "confzoo.cfg"
    inreplace "confzoo.cfg",
              ^dataDir=.*, "dataDir=#{var}runzookeeperdata"
    (etc"zookeeper").install "confzoo.cfg"

    (pkgshare"examples").install "conflogback.xml", "confzoo_sample.cfg"
  end

  def post_install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("default_logback_xml")

    defaults = etc"zookeeperdefaults"
    defaults.write(default_zk_env) unless defaults.exist?

    logback_xml = etc"zookeeperlogback.xml"
    logback_xml.write(tmpdir"default_logback_xml") unless logback_xml.exist?
  end

  service do
    run [opt_bin"zkServer", "start-foreground"]
    environment_variables SERVER_JVMFLAGS: "-Dapple.awt.UIElement=true"
    keep_alive successful_exit: false
    working_dir var
  end

  test do
    output = shell_output("#{bin}zkServer -h 2>&1")
    assert_match "Using config: #{etc}zookeeperzoo.cfg", output
  end
end