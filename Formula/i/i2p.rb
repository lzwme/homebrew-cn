class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https:geti2p.net"
  url "https:github.comi2pi2p.i2preleasesdownloadi2p-2.6.1i2psource_2.6.1.tar.bz2"
  sha256 "e6ce1704da6ac44909b9ee74b376e3ba10d27a287840b28caaf51dfae0903901"
  license :cannot_represent

  livecheck do
    url :stable
    regex(^i2p[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3349e0aef479a4f30ce893986d2363b5add7741ec7abbe426142822cf5926db4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "198e4a2a852b93d5ad82cc5080fd9e2cac27e0a4e6d2340cfdb1483422773136"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e53ce9fcf2d9aac0bccf7aae370df98f7e797f9c8ce5833bdb736d8242e1b812"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d67a04c5762d6f43605edc8e9722f9565bb8328c58040edd9b05068a4dcf699"
    sha256 cellar: :any_skip_relocation, ventura:        "fd2d80a765d954d5847dcb4a8b6f0a93f6bd33c57c210bfe1bb7fa94294b14c3"
    sha256 cellar: :any_skip_relocation, monterey:       "a02cf7d489e0040285374929407c7f06322a77448aaa8e701f7ae3cdbc70e317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e5d54338b6ea52c6639c4551926e12da1c89a22eee9d6e320ecc0d08126bed"
  end

  depends_on "ant" => :build
  depends_on "gettext" => :build
  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "ant", "preppkg-#{os}-only"

    libexec.install (buildpath"pkg-temp").children

    # Replace vendored copy of java-service-wrapper with brewed version.
    rm libexec"libwrapper.jar"
    rm_r(libexec"libwrapper")
    jsw_libexec = Formula["java-service-wrapper"].opt_libexec
    ln_s jsw_libexec"libwrapper.jar", libexec"lib"
    ln_s jsw_libexec"lib#{shared_library("libwrapper")}", libexec"lib"
    cp jsw_libexec"binwrapper", libexec"i2psvc" # Binary must be copied, not symlinked.

    # Set executable permissions on scripts
    scripts = ["eepget", "i2prouter", "runplain.sh"]
    scripts += ["install_i2p_service_osx.command", "uninstall_i2p_service_osx.command"] if OS.mac?

    scripts.each do |file|
      chmod 0755, libexecfile
    end

    # Replace references to INSTALL_PATH with libexec
    install_path_files = ["eepget", "i2prouter", "runplain.sh"]
    install_path_files << "Start I2P Router.appContentsMacOSi2prouter" if OS.mac?
    install_path_files.each do |file|
      inreplace libexecfile, "%INSTALL_PATH", libexec
    end

    inreplace libexec"wrapper.config", "$INSTALL_PATH", libexec

    inreplace libexec"i2prouter", "%USER_HOME", "$HOME"
    inreplace libexec"i2prouter", "%SYSTEM_java_io_tmpdir", "$TMPDIR"
    inreplace libexec"runplain.sh", "%SYSTEM_java_io_tmpdir", "$TMPDIR"

    # Wrap eepget and i2prouter in env scripts so they can find OpenJDK
    (bin"eepget").write_env_script libexec"eepget", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin"i2prouter").write_env_script libexec"i2prouter", JAVA_HOME: Formula["openjdk"].opt_prefix
    man1.install Dir["#{libexec}man*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}i2prouter status", 1)
  end
end