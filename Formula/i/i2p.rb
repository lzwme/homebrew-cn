class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https:geti2p.net"
  url "https:github.comi2pi2p.i2parchiverefstagsi2p-2.8.1.tar.gz"
  sha256 "e41d586c6d68735ece638459a8f3954581e1eefded9a810e56fbb26fe95f6893"
  license :cannot_represent

  livecheck do
    url :stable
    regex(^i2p[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd86478ec232802b19bb9ed3edfd106c16c0406fe04d54e35faee5a4b172fc20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a9dcc6ef3766be3330b819a749ff0eb6cc132a8b876fc47371aec9e6b735c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7354dc5211c8a5a3f89eb165648b3c62d891f3b6ba0ac0184a6234b30d467b98"
    sha256 cellar: :any_skip_relocation, sonoma:        "4570ad4e3e3cab9c57a2118e2b4f96904af8304d1df4ac4ba19d0a32d3b5e50d"
    sha256 cellar: :any_skip_relocation, ventura:       "dc4ee1a92a6e3c10657f0a170f6ca9430bc9ab0481e077195d3cd6ef23dbf5a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404750c6155cbaa0ac12d85e839831c46c784ac3c5bf8924efb082817aa68de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84964e56cd7ada0f7721a9f14175d6ac85559a5701a176e092eda67d2bee521e"
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