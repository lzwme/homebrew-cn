class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https:geti2p.net"
  url "https:github.comi2pi2p.i2preleasesdownloadi2p-2.5.2i2psource_2.5.2.tar.bz2"
  sha256 "f23d0746d72a55cccbd17f40762e491ae1b42cdf55d7e73404d213a84985ca73"
  license :cannot_represent

  livecheck do
    url :stable
    regex(^i2p[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7117134b8cffd8e6ef58bc8d393b7cd9c7068c5bf743a56234967f9e49384c72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d51ccab1f4e612bf307cfd76366b1976a829f70785b8057ec946d0b9a3327a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc5918119e3d9091012fb8a2189f8e6e0a56f0d5ceb9ae2c8fc81d1d176f6f28"
    sha256 cellar: :any_skip_relocation, sonoma:         "180129f82a926308e8e6889c4b043b9b638bdb9e400407db87638203930c28d8"
    sha256 cellar: :any_skip_relocation, ventura:        "08c2622583d0f88a5d208465828457c1a3c8e9fe1b84056cf1ed62d89140b7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "bedd4389f7e24fab95bd2c77259a25e55c5896a20d8f770837902cf55af5b306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4badf064f3fec7b9bbc6c08d0a037a79b4d9dfef6c2afb79f83aeb5a4dc6fe19"
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
    rm_rf libexec"libwrapper"
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