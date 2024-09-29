class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audiovideo downloader"
  homepage "https:github.comyt-dlpyt-dlp"
  url "https:files.pythonhosted.orgpackages7d3fc63b11419d7adacde35b39e7e62aef1be6ce9ff3d2219fae024962ab4a53yt_dlp-2024.9.27.tar.gz"
  sha256 "86605542e17e2e23ad23145b637ec308133762a15a5dedac4ae50b7973237026"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e89d072f936d913fdc05541acdf32e2095b79e35517a45556f4188dede2eeacd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67f0458d9b79242588a15b5f0fa2e2ad07414b8ef6ab1d41909ffdc0565af954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0105df9af63f3c40607be108c8d9f535b76a9f2d4ff5dfb498f334ba3045b043"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b39583184a0a59f2e4a0647535a034cfa80285981bd11983f68bc7430719759"
    sha256 cellar: :any_skip_relocation, ventura:       "ed82afe89320d43cad7c8537e49d3f62f5180a2652f3fd2dbf3882be2e17e27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb6f6c22baa7d30978083f76faebac0b83ef7e9ca950d31e86c110d654e595c"
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
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackagese2739223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fdwebsockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
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