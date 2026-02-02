class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/93/b3/025d41aa2b5b814c0898a4c5b2a9aa210192f616738aac5a86ef5780f0f6/yt_dlp-2026.1.31.tar.gz"
  sha256 "16767a3172cbb7183199f4db19e34b77b19e030ab7101b8f26d6c9e6af6f42ae"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "534466fb651ae9570f666b9917f6c271fdeee3e2c1ac094414aeb7697e61c36d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd94679c02b7c813794cfd144bc37adcbba4ac7a126bd0af1181d84c7ef7ae7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbfe57cc51b659551c8615cc9f32f0ebc2ce30c4fb69a2dde9d5c0a70aed7e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2b88c7c547f3e5a1521d0d1d623fb25af579dbf84827597d9508959634ff043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75d743b346a335f234fe6ac1161329ff2592f6470e69993d9a5850678ad6d99b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f3e6d2cc2163a328068bad452ae3efb1c69c6ed99ccf2f2e31dcfc205cc06d8"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
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
    url "https://files.pythonhosted.org/packages/e9/80/4b6c7f91b373e01cdc18080f41fa399592945abce7db74c2e6d0fb8468db/yt_dlp_ejs-0.4.0.tar.gz"
    sha256 "3c67e0beb6f9f3603fbcb56f425eabaa37c52243d90d20ccbcce1dd941cfbd07"
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