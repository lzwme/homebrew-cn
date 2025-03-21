class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https:cassandra.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=cassandra5.0.3apache-cassandra-5.0.3-bin.tar.gz"
  mirror "https:archive.apache.orgdistcassandra5.0.3apache-cassandra-5.0.3-bin.tar.gz"
  sha256 "fe1652e418c410b4eb77ae61def6934175759334171f9fdff0e455f77971515d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3966d3906adbb114e9b0a5967c9299079944904fcea9ad1518f84ee923904db"
    sha256 cellar: :any,                 arm64_sonoma:  "1b738516ad7da366c62cb7f20787fa845b0780c7cde4c5e6efb94c6aa3629b25"
    sha256 cellar: :any,                 arm64_ventura: "b7035537b67a4007bee47a4f63d7fd3dd629da61334ecaac6e6262dc547a53cd"
    sha256 cellar: :any,                 sonoma:        "3e9f6d90decfa9eecc8b439289e0c8a78ea039a3a59407ea7d52e2d76da969f6"
    sha256 cellar: :any,                 ventura:       "66c1e713dcd291ef19d000123ac2eb1e30719434961b4cfc60864e18ac2f938a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc54200fe827602f5ea797a7c4e689b7cbbafeb0994c72d104918c7d243e30e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b105d1c8ce23ce4001923f010c7e29b6746f9a1ae86b842a6774ea3bbc7c6e"
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