class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audiovideo downloader"
  homepage "https:github.comyt-dlpyt-dlp"
  url "https:files.pythonhosted.orgpackages88775e86a5345fe1cf5bad022a1b7323c9934c6a867e886fdc0cae44de8a0589yt_dlp-2025.6.25.tar.gz"
  sha256 "242b648e1a18ab04bdd4cc175a317fe8ec3ad7d0175eee9f981912624b3d6c8b"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3db1da3736c05ff3838216282355ae0294e4d30ed1786f6b3c2e91e6240355a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbd1411792da3fdd61c08d18beaae8a88300c63a21611d21523e72d8585b3ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a042dcfafcccd17f3b141f799d3dd88574b4ed8da44f250f4d6b0f971a6f89b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f17c649cce1dc8d23d38b00501ef77b94c747697b37e2dd1325a57ac05b2d0a"
    sha256 cellar: :any_skip_relocation, ventura:       "55f77a0d89e75cc9f260b6cb3022c1597df49002f782f98eea24eba4c0d09483"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e2682851169a4172648647c0356b35feeea31c233c457e2dffe222659d457a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a479fa0ec001e5cab1cbaa6834162e773fb356579b9ac0b214b8285a7a7cc313"
  end

  head do
    url "https:github.comyt-dlpyt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "brotli" do
    url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "mutagen" do
    url "https:files.pythonhosted.orgpackages81e664bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackagesc985e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages21e626d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
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
    system bin"yt-dlp", "https:raw.githubusercontent.comHomebrewbrewrefsheadsmasterLibraryHomebrewtestsupportfixturestest.gif"

    system bin"yt-dlp", "--simulate", "https:x.comXstatus1922008207133671652"
  end
end