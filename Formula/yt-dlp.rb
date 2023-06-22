class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/36/9a/13eee74e6a621ab42d2b8c7fd7daf6e943af1a8269aa966718fae177a64b/yt-dlp-2023.6.21.tar.gz"
  sha256 "56c35d1ad3ecfb828c3b89ffe07b235b354eddd82e1a31ddc3d16eb8c3e71e8e"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea8531b681b6b2bc12c1467b9f2a444582bebe48953918afa72ea18b80302f9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48ad85a76573a13c6c2946ffa6f23ceeaa3ed1b33b1fc95120476433ef161a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40bc5f4e0cde651c93246e8fdda69fe647347ceb651c2b672faf3d2b1111db65"
    sha256 cellar: :any_skip_relocation, ventura:        "e185eaeb244000d6cb7bb3e58e675f9de8fdd13162ee7e9bdc1662d3f52e0e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "21342edf9ec8ec9aae3723a078f058e81fb62e8578f1bd3738613c6cdcb47726"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a5e649be23be4f2231c475c87a680a86baafb90cd06b639a608969b545d6ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2408d8099b83249a78fb8f1fde59b2446eb27c64dfe93cf05e5e779456a59445"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/40/92/efd675dba957315d705f792b28d900bddc36f39252f6713961b4221ee9af/pycryptodomex-3.18.0.tar.gz"
    sha256 "3e3ecb5fe979e7c1bb0027e518340acf7ee60415d79295e5251d13c68dde576e"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  def install
    system "make", "pypi-files" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end