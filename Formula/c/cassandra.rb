class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https:cassandra.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=cassandra5.0.2apache-cassandra-5.0.2-bin.tar.gz"
  mirror "https:archive.apache.orgdistcassandra5.0.2apache-cassandra-5.0.2-bin.tar.gz"
  sha256 "d721834207838b9d01919dfc33625ad17b50fea03bf9f76cdd8d3ae3a8fd2947"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d93811c988659dac067376da548017ae75ed5386588c0ab46f616dc3de91b06c"
    sha256 cellar: :any,                 arm64_sonoma:  "8aacacac5194c0b57467acc457c7267457f11b323fad6e8e1501cfe85caa2d93"
    sha256 cellar: :any,                 arm64_ventura: "ae588dbb3d91beddea60d6c22635f8bc42a443425cefabb35f899e85f24c50dd"
    sha256 cellar: :any,                 sonoma:        "5ae4378828dcbf84131cef2132a2ea91b9c4ccb75d7e0ba42abd14bd802f24b8"
    sha256 cellar: :any,                 ventura:       "7a35926ce1e8f6bda081ff85fd32421eadd643b67dcc6a7b4fa3d3df2ee1ec22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c79b9928798c75d5a32d1dd71c62cb7343a7c89713a5d500325302206403b9c"
  end

  depends_on "libev"
  depends_on "openjdk@17"
  depends_on "python@3.11" # required 3.8-3.11, https:github.comapachecassandrablobtrunkbincqlsh#L65-L73

  conflicts_with "emqx", because: "both install `nodetool` binaries"

  resource "cassandra-driver" do
    url "https:files.pythonhosted.orgpackagesb26fd25121afaa2ea0741d05d2e9921a7ca9b4ce71634b16a8aaee21bd7af818cassandra-driver-3.29.2.tar.gz"
    sha256 "c4310a7d0457f51a63fb019d8ef501588c491141362b53097fbc62fa06559b7c"
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

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    (var"libcassandra").mkpath
    (var"logcassandra").mkpath

    python3 = "python3.11"
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
              "JAVA_HOME=#{Language::Java.overridable_java_home_env("17")[:JAVA_HOME]}"
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