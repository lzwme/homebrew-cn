class Copyparty < Formula
  include Language::Python::Virtualenv

  desc "Portable file server"
  homepage "https://github.com/9001/copyparty"
  url "https://files.pythonhosted.org/packages/cf/a3/9b4d3accfa356ce50682d3fb89684a0b647ee329472ba24a117621d81240/copyparty-1.20.4.tar.gz"
  sha256 "9dd9c688b5e7e43f98ddfa56174ba1bc2da595acc378f4ff443ee74dc22b656f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de13f479ad4054196237f1093d1392d5691cb2a57e960284f518597511793535"
    sha256 cellar: :any,                 arm64_sequoia: "b3c55de183529f761655e3cf5ba63dc88d3f26e55841190b5f1601bdd03e5765"
    sha256 cellar: :any,                 arm64_sonoma:  "79fe7bf69f0c31be303faf8fa6f5507dce5e297faa1bdce5db2bcb2b1b357de0"
    sha256 cellar: :any,                 sonoma:        "df7f9986cecfe3ed78db6ae51b46be30d6b5dbaa394503810fa435db02da8b80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01afa94437e6ab141eab0975e453ebe11a30fb50df26f48a6ec8f854476e89ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "905ba465bdab39175effe78a6f3982a3b0abf7a6c3ca049d6e192f032f96aab3"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "glib"
  depends_on "python@3.14"
  depends_on "vips"
  depends_on "zeromq"

  on_macos do
    depends_on "gettext"
  end

  pypi_packages package_name:     "copyparty[thumbnails2,audiotags,ftpd,ftps,tftpd,pwhash,zeromq]",
                exclude_packages: ["cffi", "cryptography", "pycparser"]

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

  resource "pyvips" do
    url "https://files.pythonhosted.org/packages/2d/6a/282936de9faac6addf6bc8792c18e006489d0023ffd8856b8643f54d0558/pyvips-3.1.1.tar.gz"
    sha256 "84fe744d023b1084ac2516bb17064cacd41c7f8aabf8e524dd383534941b9301"
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