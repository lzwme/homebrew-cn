class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https:github.commps-youtubeyewtube"
  url "https:github.commps-youtubeyewtubearchiverefstagsv2.10.5.tar.gz"
  sha256 "8100466a5e89c84249d882e2e9ea9ff282a2d4f7f68135157cb942e6eb927b29"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "205691b60bdbadff7eb4a3d90517003d8f475b3e1ef1879958adfe7d18080c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8d5c8f00a0058bfe22ac2304a4a8cadab8e1e05f148876b02b71921860d21d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fb2cf8a880c1a91fab67b2b72b575cfb3ed1a80f4d8da1db8f0c8484259a52c"
    sha256 cellar: :any_skip_relocation, sonoma:         "daabcf1915cfbdcbc4d477ad514511b370f83a60db132d81456c1381c34d6312"
    sha256 cellar: :any_skip_relocation, ventura:        "da8ed830a6a4514afe271c16b67e69fbdff3a8b88bac007e0c0575efc023aac5"
    sha256 cellar: :any_skip_relocation, monterey:       "faf586671fa377679754af05385f8381fa2314cf18cab9e2e1427c7ee5891c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a68f57e2f5755716682c3c7a5c4c27380120f502e5870694e8745bc7c23eaf97"
  end

  depends_on "mplayer"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "brotli" do
    url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages07b3e02f4f397c81077ffc52a538e0aec464016f1860c472ed33bd2a1d220cc5certifi-2024.6.2.tar.gz"
    sha256 "3cd43f1c6fa7dedc5899d69d3ad0398fd018ad1a17fba83ddaf78aa46c747516"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages5c2d3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "mutagen" do
    url "https:files.pythonhosted.orgpackages81e664bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages31a4b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pylast" do
    url "https:files.pythonhosted.orgpackagesbff284e992deea30c5195f7166387295049bd6b29f23a6a1a03ff8c16f59436fpylast-5.3.0.tar.gz"
    sha256 "637943b1b0e6045dd85ed7389db6071a1fea45cc7ff90dc6126fd509ca6fae2f"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e627a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "youtube-search-python" do
    url "https:files.pythonhosted.orgpackages913cdc669b0308e49f294df67bddbb16ff3eefe5b5da6fa37ead922a8301926byoutube-search-python-1.6.6.tar.gz"
    sha256 "4568d1d769ecd7eb4bb8365f04eec6e364c5f70eec7b3765f543daebb135fcf5"
  end

  resource "yt-dlp" do
    url "https:files.pythonhosted.orgpackages5ac3ebb3aa4b46550aaa1e125db81db8c4efbfe1436221e8ed60ee5a18930890yt_dlp-2024.7.2.tar.gz"
    sha256 "2b0c86b579d4a044eaf3c4b00e3d7b24d82e6e26869fa11c288ea4395b387f41"
  end

  # Fix SyntaxWarning's on python 3.12
  # https:github.commps-youtubeyewtubepull1263
  patch do
    url "https:github.commps-youtubeyewtubecommit0db8c9e567399b2da0c77d95834832cbb4082544.patch?full_index=1"
    sha256 "1c28b5b8fb8a66db310e326274029e5b097841af4d944af965899447c0e600ae"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Install the optional mpv app with Homebrew Cask:
        brew install --cask mpv
    EOS
  end

  test do
    system bin"yt",
      "set checkupdate false,",
      "set ddir \"#{testpath}\",",
      "youtube-dl test video,", "d 1,", "q"
    downloaded_file = (testpath"mps").children.first
    file_info = Utils.safe_popen_read("file", "--brief", downloaded_file).strip
    assert_match(^(WebM)|(.*MP4.*)$, file_info)
  end
end