class Copyparty < Formula
  include Language::Python::Virtualenv

  desc "Portable file server"
  homepage "https://github.com/9001/copyparty"
  url "https://files.pythonhosted.org/packages/83/b9/15b2c3f9ab5d0843d9ad3bd827ce389eaa272a2fd8c095e46f1ed96abaf2/copyparty-1.20.6.tar.gz"
  sha256 "1fc00d302505f56df2568193b8e224778eacfddfc70ffaa276c3be1a642df98e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "511a544d44af87ea9d4fcf3b58a7d245e80eb9ee99c134770a8a3c742164c261"
    sha256 cellar: :any,                 arm64_sequoia: "ec2bce74c7bdd10d262fb2886ffa94195e0fc25ec0dd6b76d396bf1c2b402309"
    sha256 cellar: :any,                 arm64_sonoma:  "bc6c22e26e08d2d6251d3edb94c63031854ac406360035c48be043626ed6ee1c"
    sha256 cellar: :any,                 sonoma:        "de87bc17293154dbff3a0e2d03ffc822c98eb4f3c0bed3d65d048e8ee99197ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ea9568a1e0b6bc32450e6a8d2d9fa17950c91cb8ca9b18daa6137d3454b76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f89b29aecd65a3e44df6ed1742f7afe7b91ea44e3dce37a97d8651ea7beff0de"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "zeromq"

  on_macos do
    depends_on "gettext"
  end

  pypi_packages package_name:     "copyparty[thumbnails,audiotags,ftpd,ftps,tftpd,pwhash,zeromq]",
                exclude_packages: %w[cffi cryptography pillow pycparser]

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/0e/89/ce5af8a7d472a67cc819d5d998aa8c82c5d860608c4db9f46f1162d7dab9/argon2_cffi-25.1.0.tar.gz"
    sha256 "694ae5cc8a42f4c4e2bf2ca0e64e51e23a040c6a517a85074683d3959e1346c1"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/5c/2d/db8af0df73c1cf454f71b2bbe5e356b8c1f8041c979f505b3d3186e520a9/argon2_cffi_bindings-25.1.0.tar.gz"
    sha256 "b957f3e6ea4d55d820e40ff76f450952807013d361a65d7f28acc0acbf29229d"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "partftpy" do
    url "https://files.pythonhosted.org/packages/8c/96/642bb3ddcb07a2c6764eb29aa562d1cf56877ad6c330c3c8921a5f05606d/partftpy-0.4.0.tar.gz"
    sha256 "e50db3cae27cf763c66666fe61783464f5bf0caf110cbd6e1348f91cf77859ed"
  end

  resource "pyasynchat" do
    url "https://files.pythonhosted.org/packages/ec/d2/b41df9021c12ca314146abcde7bdd3d9d37d44cc01559d7f13df459ee586/pyasynchat-1.0.5.tar.gz"
    sha256 "36665473ae730dac51e6d7dad70f8295962120c830ab692f0a31efba32687e24"
  end

  resource "pyasyncore" do
    url "https://files.pythonhosted.org/packages/4e/43/035dfe0cb01687c1940fdc008f46a43c41067e226e862df49327469764a0/pyasyncore-1.0.5.tar.gz"
    sha256 "dd483d5103a6d59b66b86e0ca2334ad43dca732ff23a0ac5d63c88c52510542e"
  end

  resource "pyftpdlib" do
    url "https://files.pythonhosted.org/packages/fc/67/3299ce20585601d21e05153eb9275cb799ae408fe15ab93e48e4582ea9fe/pyftpdlib-2.1.0.tar.gz"
    sha256 "5e92e7ba37c3e458ec458e5c201e2deb992cb6011c963e6a8512a634d8d80116"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/04/0b/3c9baedbdf613ecaa7aa07027780b8867f57b6293b6ee50de316c9f3222b/pyzmq-27.1.0.tar.gz"
    sha256 "ac0765e3d44455adb6ddbf4417dcce460fc40a05978c08efdf2948072f6db540"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      If you need to generate thumbnails for video/audio files:
        brew install ffmpeg
      If you need to automatically create a CA and server-cert on startup:
        brew install cfssl
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/copyparty --version")

    require "pty"

    port = free_port
    PTY.spawn(bin/"copyparty", "-q", "-p", port.to_s, "-lo", testpath/"log.txt") do |_r, w, pid|
      sleep 3
      w.close
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    assert_path_exists testpath/"log.txt"
    output = File.read(testpath/"log.txt")
    assert_match "listening @ [::]:#{port}", output
  end
end