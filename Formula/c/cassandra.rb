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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c762c38816e0390045b7dacd748540fe5d5d6b2f3eb899345feae7d43a855f43"
    sha256 cellar: :any,                 arm64_ventura:  "b9c1354a4c899523ee897d54cdc93bd7e0569bd59a00b1239f5893cc753f905b"
    sha256 cellar: :any,                 arm64_monterey: "8c6bdf5ffeddbe5f901ffd5ae663dddf442ce2cc18146a5bf2d3cc74b2258295"
    sha256 cellar: :any,                 sonoma:         "dce5b3c5d2b03a1e49b20dbfdff5ac25cee90f4613e3147eb7ca01147109eab4"
    sha256 cellar: :any,                 ventura:        "03503111a62e38a4e68559cd4f4ee9751011e77f325fb20576055af161438778"
    sha256 cellar: :any,                 monterey:       "93251f588e156d585a6645effb9370aad0fee90234db341d011f1838309384a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e2a2458bb471147d3181b50c419e8020c8cf32171a243dd02442c8ff22ccaa"
  end

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
    url "https:files.pythonhosted.orgpackagescf2158251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afageomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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