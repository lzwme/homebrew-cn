class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https:zookeeper.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=zookeeperzookeeper-3.9.2apache-zookeeper-3.9.2.tar.gz"
  mirror "https:archive.apache.orgdistzookeeperzookeeper-3.9.2apache-zookeeper-3.9.2.tar.gz"
  sha256 "bbdea19a91d11bc55071fdd7c83109afb6ee791a7b0733fde0baaa44029cbd77"
  license "Apache-2.0"
  head "https:gitbox.apache.orgreposasfzookeeper.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fecb79b2f25954d7fdca163d50f7a7ff160016a77c47cd7c41773a2cff9b9ebc"
    sha256 cellar: :any,                 arm64_ventura:  "c6a65b0a4b92f028aeb7abe65b64e8a622ccbc06ec489ea0364436778f639a43"
    sha256 cellar: :any,                 arm64_monterey: "ace58083a2443dcc624237bc6c20d7608acdd10256757217d3282635ebd93f3d"
    sha256 cellar: :any,                 sonoma:         "a25990613de25a2459634cfa6eefe4b5e39d4b9a2e4e261ee4737030fbc7d760"
    sha256 cellar: :any,                 ventura:        "00f7c13e77818690433133c68457bbdc1d4ab91bd6ef182043c383ec26930d46"
    sha256 cellar: :any,                 monterey:       "b436e4da95c4fa3f2b939ca879142df8848e55c345dea3c3f9d557d6e1d0e9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec439135bfdff8a3a90fbffa8c5f6c649c3c62c976c39a7552cba4c7fd4074cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build

  depends_on "openjdk"
  depends_on "openssl@3"

  resource "default_logback_xml" do
    url "https:raw.githubusercontent.comapachezookeeperrelease-3.9.2conflogback.xml"
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