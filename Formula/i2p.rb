class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.1.0/i2psource_2.1.0.tar.bz2"
  sha256 "83098c1277204c5569284b32b37ef137656b27bfe15ef903eca2da7c269288d1"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a77dcbb2e35347e8a9a6d3157ac37ed7dfeae7e0f62068b9435f6aab28d128"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b367590785d89af4f0fa4a69bdee2938e86e686709e8376ac58b410180ada2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7edb7d6b0efd6e445862d6d8342eee66528ecec22a4c3009d3517e1b1d33885a"
    sha256 cellar: :any_skip_relocation, ventura:        "e9b98da624ed7e397d0af02433f90065c877ed88fddba6024ee3241a47fa7275"
    sha256 cellar: :any_skip_relocation, monterey:       "5fdff3db94d31afbb9de04844f275fd8f8492833029db8ad2f3751be9ba9e64a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc076979cd3d39d63eec64a165032fbebb37cbb703c818305e75a8e2f047a599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "717b8e132b375d4849353d8228169c099508de3df9811835d8ddc509942bda7f"
  end

  depends_on "ant" => :build
  depends_on "gettext" => :build
  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "ant", "preppkg-#{os}-only"

    libexec.install (buildpath/"pkg-temp").children

    # Replace vendored copy of java-service-wrapper with brewed version.
    rm libexec/"lib/wrapper.jar"
    rm_rf libexec/"lib/wrapper"
    jsw_libexec = Formula["java-service-wrapper"].opt_libexec
    ln_s jsw_libexec/"lib/wrapper.jar", libexec/"lib"
    ln_s jsw_libexec/"lib/#{shared_library("libwrapper")}", libexec/"lib"
    cp jsw_libexec/"bin/wrapper", libexec/"i2psvc" # Binary must be copied, not symlinked.

    # Set executable permissions on scripts
    scripts = ["eepget", "i2prouter", "runplain.sh"]
    scripts += ["install_i2p_service_osx.command", "uninstall_i2p_service_osx.command"] if OS.mac?

    scripts.each do |file|
      chmod 0755, libexec/file
    end

    # Replace references to INSTALL_PATH with libexec
    install_path_files = ["eepget", "i2prouter", "runplain.sh"]
    install_path_files << "Start I2P Router.app/Contents/MacOS/i2prouter" if OS.mac?
    install_path_files.each do |file|
      inreplace libexec/file, "%INSTALL_PATH", libexec
    end

    inreplace libexec/"wrapper.config", "$INSTALL_PATH", libexec

    # Wrap eepget and i2prouter in env scripts so they can find OpenJDK
    (bin/"eepget").write_env_script libexec/"eepget", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"i2prouter").write_env_script libexec/"i2prouter", JAVA_HOME: Formula["openjdk"].opt_prefix
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end