class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https:cassandra.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=cassandra4.1.4apache-cassandra-4.1.4-bin.tar.gz"
  mirror "https:archive.apache.orgdistcassandra4.1.4apache-cassandra-4.1.4-bin.tar.gz"
  sha256 "03447f958339ba70f717cf2cf2fd97be17876540526a86343db635a8ca523bcd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "29af2078d991d0f5d848f1d638ee3473acbaa7295c96a89491c16eefb7cbc665"
    sha256 cellar: :any,                 arm64_ventura:  "535d0a0754e658719d67c87e8ef21fbdddc259787cf27d9ca8e9eb9b746c0f49"
    sha256 cellar: :any,                 arm64_monterey: "f6fa83e35803e23a362696e403189d771d34a570debcbbed6dfc5e5043ba581f"
    sha256 cellar: :any,                 sonoma:         "82d59bccdeb6ffa0a5258acd5911e1af72779ff28331d39bf7a53ad1eac763de"
    sha256 cellar: :any,                 ventura:        "e621b3670a20073cbad0e0541506c10fca4ad77ca90e1a2a97d513323044eb49"
    sha256 cellar: :any,                 monterey:       "981632b998c1ab811f113452f2658e36c06a0a45b334bc4be958c5dc98c063d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b900589f94e0dda18ad83859e18926db52a755d10de2f22a76b32144f738916"
  end

  depends_on "libcython" => :build
  depends_on "python-setuptools" => :build
  depends_on "libev"
  depends_on "openjdk@11"
  depends_on "python@3.12"

  resource "cassandra-driver" do
    url "https:files.pythonhosted.orgpackages59283e0ea7003910166525304b65a8ffa190666b483c2cc9c38ed5746a25d0fdcassandra-driver-3.29.0.tar.gz"
    sha256 "0a34f9534356e5fd33af8cdda109d5e945b6335cb50399b267c46368c4e93c98"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "geomet" do
    url "https:files.pythonhosted.orgpackages2a8cdde022aa6747b114f6b14a7392871275dea8867e2bd26cddb80cc6d66620geomet-1.1.0.tar.gz"
    sha256 "51e92231a0ef6aaa63ac20c443377ba78a303fd2ecd179dc3567de79f3c11605"
  end

  def install
    (var"libcassandra").mkpath
    (var"logcassandra").mkpath

    python3 = "python3.12"
    venv = virtualenv_create(libexec"vendor", python3)
    venv.pip_install resources

    inreplace "confcassandra.yaml", "varlibcassandra", var"libcassandra"
    inreplace "confcassandra-env.sh", "lib", ""

    inreplace "bincassandra", "-Dcassandra.logdir=$CASSANDRA_LOG_DIR",
                               "-Dcassandra.logdir=#{var}logcassandra"
    inreplace "bincassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=\"`dirname \"$0\"`..\"",
              "CASSANDRA_HOME=\"#{libexec}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOMEconf\"",
              "CASSANDRA_CONF=\"#{etc}cassandra\""
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"lib*.jar",
              "\"$CASSANDRA_HOME\"*.jar"
      # The jammm Java agent is not in a lib subdir either:
      s.gsub! "JAVA_AGENT=\"$JAVA_AGENT -javaagent:$CASSANDRA_HOMElibjamm-",
              "JAVA_AGENT=\"$JAVA_AGENT -javaagent:$CASSANDRA_HOMEjamm-"
      # Storage path
      s.gsub! "cassandra_storagedir=\"$CASSANDRA_HOMEdata\"",
              "cassandra_storagedir=\"#{var}libcassandra\""

      s.gsub! "#JAVA_HOME=usrlocaljdk6",
              "JAVA_HOME=#{Language::Java.overridable_java_home_env("11")[:JAVA_HOME]}"
    end

    rm Dir["bin*.bat", "bin*.ps1"]

    # This breaks on `brew uninstall cassandra && brew install cassandra`
    # https:github.comHomebrewhomebrewpull38309
    pkgetc.install Dir["conf*"]

    libexec.install Dir["*.txt", "{bin,interface,javadoc,pylib,liblicenses}"]
    libexec.install Dir["lib*.jar"]

    pkgshare.install [libexec"bincassandra.in.sh", libexec"binstop-server"]
    inreplace Dir[
      libexec"bincassandra*",
      libexec"bindebug-cql",
      libexec"binnodetool",
      libexec"binsstable*",
    ], %r{`dirname "?\$0"?`cassandra.in.sh},
       pkgshare"cassandra.in.sh"

    # Make sure tools are installed
    rm Dir[buildpath"toolsbin*.bat"] # Delete before install to avoid copying useless files
    (libexec"tools").install Dir[buildpath"toolslib*.jar"]

    # Tools use different cassandra.in.sh and should be changed differently
    mv buildpath"toolsbincassandra.in.sh", buildpath"toolsbincassandra-tools.in.sh"
    inreplace buildpath"toolsbincassandra-tools.in.sh" do |s|
      # Tools have slightly different path to CASSANDRA_HOME
      s.gsub! "CASSANDRA_HOME=\"`dirname $0`....\"", "CASSANDRA_HOME=\"#{libexec}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOMEconf\"", "CASSANDRA_CONF=\"#{etc}cassandra\""
      # Core Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"lib*.jar", "\"$CASSANDRA_HOME\"*.jar"
      # Tools Jars are under tools folder
      s.gsub! "\"$CASSANDRA_HOME\"toolslib*.jar", "\"$CASSANDRA_HOME\"tools*.jar"
      # Storage path
      s.gsub! "cassandra_storagedir=\"$CASSANDRA_HOMEdata\"", "cassandra_storagedir=\"#{var}libcassandra\""
    end

    pkgshare.install [buildpath"toolsbincassandra-tools.in.sh"]

    # Update tools script files
    inreplace Dir[buildpath"toolsbin*"],
              "`dirname \"$0\"`cassandra.in.sh",
              pkgshare"cassandra-tools.in.sh"

    venv_bin = libexec"vendorbin"
    rw_info = python_shebang_rewrite_info(venv_binpython3)
    rewrite_shebang rw_info, libexec"bincqlsh.py"

    # Make sure tools are available
    bin.install Dir[buildpath"toolsbin*"]
    bin.write_exec_script Dir[libexec"bin*"]
    (bin"cqlsh").write_env_script libexec"bincqlsh", PATH: "#{venv_bin}:$PATH"
  end

  service do
    run [opt_bin"cassandra", "-f"]
    keep_alive true
    working_dir var"libcassandra"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cassandra -v")

    output = shell_output("#{bin}cqlsh localhost 2>&1", 1)
    assert_match "Connection error", output
  end
end