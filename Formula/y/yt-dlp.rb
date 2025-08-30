class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/f4/d4/d9dd231b03f09fdfb5f0fe70f30de0b5f59454aa54fa6b2b2aea49404988/yt_dlp-2025.8.27.tar.gz"
  sha256 "ed74768d2a93b29933ab14099da19497ef571637f7aa375140dd3d882b9c1854"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b418e2aa68fc770fcab422b6bb68973039b1aef0a5b7bead9b16a832f3863827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0546d84b5eaf0d63064e000b741c3158b977b421a41f456c6f170d15585fa4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad3a5976143e08b2aaef8e75ce58af3bd07f53c61eda6375248d4d0823e47623"
    sha256 cellar: :any_skip_relocation, sonoma:        "596dcc84580587e952bad51c60d66334915a18fef43a2dd225bf1c285781e414"
    sha256 cellar: :any_skip_relocation, ventura:       "170783d2bc30099c98e0f9d6bcc59dbd4f99fb6cacf201961b2f0be7e7111b3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c85b49af939da8b7075e366ad07f6aa87111f01e6bf82fdb8e8bda74818c59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "665afe0e18a30ca607134ae1983d7bb28ff1cee4cf5b9f42c5e98dec03fd1b9b"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  def install
    system "gmake", "lazy-extractors", "pypi-files" if build.head?
    virtualenv_install_with_resources
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    system bin/"yt-dlp", "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/brew/refs/heads/master/Library/Homebrew/test/support/fixtures/test.gif"

    system bin/"yt-dlp", "--simulate", "https://x.com/X/status/1922008207133671652"
  end
end