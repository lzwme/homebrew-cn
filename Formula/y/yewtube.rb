class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https:github.commps-youtubeyewtube"
  url "https:github.commps-youtubeyewtubearchiverefstagsv2.12.0.tar.gz"
  sha256 "0a45b09fed598d29275f62847cbb556c948cd46d2b7bb0f6b0996b2ce05b77fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad5e55244f5748877524a5e37baeb86b74b0ba28b56f1e10382ace239a3cdca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9812c083a90eec94614de37627182824071a77537eb7e87501082ccc2a7f249"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "166d140f6335a6ca3c027554d01983caa238504c414bad90312c026cd1ec8c36"
    sha256 cellar: :any_skip_relocation, sonoma:        "9153c7798f12b1def2abfc1acf634682edd654f94edf567edd32df60399bd1c4"
    sha256 cellar: :any_skip_relocation, ventura:       "1c565723218ccb1bf9c12cf2e47b50e455b6a2b102c36d59e519e286595435d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993bd2eddc10ca7a1050f4e61e0535e8875ce81c35e80ed5b2f045c5c60c0929"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
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
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages8f1c78687e0267b09412409ac134f10fd14d14ac6475da892a8b09a02d0f6ae2websockets-13.0.1.tar.gz"
    sha256 "4d6ece65099411cfd9a48d13701d7438d9c34f479046b34c50ff60bb8834e43e"
  end

  resource "youtube-search-python" do
    url "https:files.pythonhosted.orgpackages913cdc669b0308e49f294df67bddbb16ff3eefe5b5da6fa37ead922a8301926byoutube-search-python-1.6.6.tar.gz"
    sha256 "4568d1d769ecd7eb4bb8365f04eec6e364c5f70eec7b3765f543daebb135fcf5"
  end

  resource "yt-dlp" do
    url "https:files.pythonhosted.orgpackagesd82883ec43b75afd9e9840680757000fc75e68d3d221621090b3ca7601ca8129yt_dlp-2024.8.6.tar.gz"
    sha256 "e8551f26bc8bf67b99c12373cc87ed2073436c3437e53290878d0f4b4bb1f663"
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
    # Fails with bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"yt",
      "set checkupdate false,",
      "set ddir \"#{testpath}\",",
      "youtube-dl test video,", "d 1,", "q"
    downloaded_file = (testpath"mps").children.first
    file_info = Utils.safe_popen_read("file", "--brief", downloaded_file).strip
    assert_match(^(WebM)|(.*MP4.*)$, file_info)
  end
end