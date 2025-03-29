class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audiovideo downloader"
  homepage "https:github.comyt-dlpyt-dlp"
  url "https:files.pythonhosted.orgpackages8ccfb944738d1508948e00b6d71b2305448ca4ea18fcc1c6ba0c2118270f2e82yt_dlp-2025.3.27.tar.gz"
  sha256 "30cb078f803b539b2a66521c5ec86d328c07f74aeca9440069e58619c299cf15"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c66fa547b261ce672b333a6b1e9556698dfa9c8d775ce9e20f86883350c409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822849b21379c2ceeaa092536c8dbaf8a74028ce0c0328b7c05617b1d4909be7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3222144158409d44b018a00a1d52fdbbc285b85a96cb6d9e301e3b8c9f9c6831"
    sha256 cellar: :any_skip_relocation, sonoma:        "1165721619815469bcd03fecc1a1e471417532cf3e62c48d6097571069309c6f"
    sha256 cellar: :any_skip_relocation, ventura:       "8fb536a0c9553e81e07a0ffc1c741c963f23e47c85dc4a280643fc57251bb6db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "148f8e78423b3062857ad1a652a67ec48f6c616baf7091ffde3a818190bf675e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e2fedd2c1a67a6f18d4a64f0b8d2a1b8ec1f7751a9e927b49d373a80a5beb6"
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
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
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
    url "https:files.pythonhosted.orgpackagesbad5861a7daada160fcf6b0393fb741eeb0d0910b039ad7f0cd56c39afdd4a20pycryptodomex-3.22.0.tar.gz"
    sha256 "a1da61bacc22f93a91cbe690e3eb2022a03ab4123690ab16c46abb693a9df63d"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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

    # YouTube tests fail bot detection
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"yt-dlp", "--simulate", "https:www.youtube.comwatch?v=pOtd1cbOP7k"
    system bin"yt-dlp", "--simulate", "--yes-playlist", "https:www.youtube.comwatch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end