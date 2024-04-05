class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.4.0/i2psource_2.4.0.tar.bz2"
  sha256 "30ef8afcad0fffafd94d30ac307f86b5a6b318e2c1f44a023005841a1fcd077c"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45fdcb057904524c6a036a817498126b1db5ebe426a0f08657acf6ecd547f141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f8df990e1aa4dfb4fc749e193b3525e1152d2eab7156104975ea3e7d14ed3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2da5f989c798cbc559d0037c33f520e3dad93e6bdd61f1be1da051e172fbbbfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c29dc3fc393d0947d40fda159986f766a921b14ca946cd197a74653c67bf3d7"
    sha256 cellar: :any_skip_relocation, ventura:        "57339b9ef1afaad2cce76ca7c2fdc18da6c0018a98272220241b986f9cbcc2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "22ab24f06fcc5cc2fb44283c7fdbcf9e6d224e7a12cf8b122276456a7f86f304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a61c4e7a412b6b88094606850a2dcecfeb6fb3d40f228d579407015176847614"
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

    inreplace libexec/"i2prouter", "%USER_HOME", "$HOME"
    inreplace libexec/"i2prouter", "%SYSTEM_java_io_tmpdir", "$TMPDIR"
    inreplace libexec/"runplain.sh", "%SYSTEM_java_io_tmpdir", "$TMPDIR"

    # Wrap eepget and i2prouter in env scripts so they can find OpenJDK
    (bin/"eepget").write_env_script libexec/"eepget", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"i2prouter").write_env_script libexec/"i2prouter", JAVA_HOME: Formula["openjdk"].opt_prefix
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end