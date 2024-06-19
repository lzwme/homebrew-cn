class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audiovideo downloader"
  homepage "https:github.comyt-dlpyt-dlp"
  url "https:files.pythonhosted.orgpackages089c6dc54bc591d50eb9378a0e0442e5b69f28eff1ead4f234b7837b6d582761yt_dlp-2024.5.27.tar.gz"
  sha256 "3566c0de240d0cd3d1c2285ce655f72ca38dfc618d634d46818b00d89d5288be"
  license "Unlicense"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e78db03af42fd544b1ab7daf23bf4ea0f7dafd07827d4559afa1eabb8af44569"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546a1db4ba55a6162be620bda8f88ad3d71dc2a580ddd5469be9b8050592295a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cee6de6f7688d6b85a7cabcf1d772f0bd0625106f679f8f34b09ba5ca8c388ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "439db6950f770dc92aad28de627d5f6fbb312c7505e566f2c78309aa60183c15"
    sha256 cellar: :any_skip_relocation, ventura:        "bf2d7098276459ada0db6f4df2ef7b2fb674434f0b5bb56e2dcb1a9ab88c44ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4f5941f96ee279c89b4cf8120deb4bf1696d2abc48a8a7fd84d647dba5b26cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548390a6e7736eb59992842beb42e2fb164951f7bfd4607857ea4debbdef6c6e"
  end

  head do
    url "https:github.comyt-dlpyt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "brotli" do
    url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e627a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def install
    system "gmake", "lazy-extractors", "pypi-files" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec"sharemanman1yt-dlp.1"
    bash_completion.install libexec"sharebash-completioncompletionsyt-dlp"
    zsh_completion.install libexec"sharezshsite-functions_yt-dlp"
    fish_completion.install libexec"sharefishvendor_completions.dyt-dlp.fish"
  end

  test do
    system "#{bin}yt-dlp", "--simulate", "https:www.youtube.comwatch?v=pOtd1cbOP7k"
    system "#{bin}yt-dlp", "--simulate", "--yes-playlist", "https:www.youtube.comwatch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end