class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/66/6f/7427d23609353e5ef3470ff43ef551b8bd7b166dd4fef48957f0d0e040fe/yt_dlp-2026.3.3.tar.gz"
  sha256 "3db7969e3a8964dc786bdebcffa2653f31123bf2a630f04a17bdafb7bbd39952"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "622f6652258da46fafd7adf8f3615d1144e9199f527a59a3bafa56951be6fb78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f832f7a139bd9014f866a7a2ba7801367a35e54c2913823f756e1db1d221a481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946a3057f005c56258f111523212efdda590197c386b909da2f895863f3882cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b14fcfdc4e066e67bdf0d28e47e8eb7f8e3f14533bdc267ef7fcb669ca1bbb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22c70896e2c80292643fd354a55653d7d573c7ffb02e5e8758b508805064c9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c3fe4408507a4d5430c620566731e0909e23eafe921d7e8a88268a16da004f"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

    depends_on "pandoc" => :build
  end

  depends_on "node" => :build # https://github.com/yt-dlp/ejs/issues/37
  depends_on "certifi"
  depends_on "deno"
  depends_on "python@3.14"

  pypi_packages package_name:     "yt-dlp[default]",
                exclude_packages: "certifi"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  resource "yt-dlp-ejs" do
    url "https://files.pythonhosted.org/packages/6b/0d/b9e4ab1b47cdeba0842df634b74b3c0144307640ad5b632a5e189c4ab7ce/yt_dlp_ejs-0.5.0.tar.gz"
    sha256 "8dfae59e418232f485253dcf8e197fefa232423c3af7824fe19e4517b173293b"
  end

  def install
    system "make", "lazy-extractors", "pypi-files" if build.head?
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