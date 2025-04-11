class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https:cassandra.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=cassandra5.0.4apache-cassandra-5.0.4-bin.tar.gz"
  mirror "https:archive.apache.orgdistcassandra5.0.4apache-cassandra-5.0.4-bin.tar.gz"
  sha256 "d3056b75f35c2bd2abbdf7b0bf9f5f816a61328ca136c5580a8fb0c9f57c5e30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29475946c5427925812bf775798604bf579e38114216f3f72d92155119614f27"
    sha256 cellar: :any,                 arm64_sonoma:  "938e64bd5fac77de94e4052069b983607b3500dc7674d5c313d8288235b4e65d"
    sha256 cellar: :any,                 arm64_ventura: "4b914a05ea2fd59ba9718a18edc1ddc36480c72460577f585d3ca530a11e0956"
    sha256 cellar: :any,                 sonoma:        "c9972b85feb6d2ebf1be400e8a2dd6bd483dc734c1227a987c344aca021414e6"
    sha256 cellar: :any,                 ventura:       "051fc59c3aa2739ad3cd2594e9184ed1a3a2b70a74a7bb65a45af6e79d4ca344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c6d368d114ce336647e325c30f2c9f684a05f6038f32baa582e42f708e3f1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef738122eed736cfb35c09d542ab939c1b5a9f35c5c8e7bd115ac0c624d3001"
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
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "geomet" do
    url "https:files.pythonhosted.orgpackagescf2158251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afageomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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