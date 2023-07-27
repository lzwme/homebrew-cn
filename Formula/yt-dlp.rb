class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/db/c5/e08a7aa42c962d34201151fa6b825fed7fbb998a1b612f37c7eb93a7e764/yt-dlp-2023.7.6.tar.gz"
  sha256 "cb58373869c8ccb5034746f91cfccd6d25ea697090dfd6f93e9034d51eb4aed2"
  license "Unlicense"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17eb5a5330d811c23586e08c22c492f915b80be0f298336c7628861d65b65d0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6669c1316d809b5ae554e37f323b22bb567462a96e8cd7145cc03c1ffc018342"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0cafc6a31685d55b9e7f021f99f8677562b85fe4bdb0001b916bafa8257f77f"
    sha256 cellar: :any_skip_relocation, ventura:        "b48c2ecac58896b91993107202a1b523f7a4094cc7bdcb53a6993af159b5e2f3"
    sha256 cellar: :any_skip_relocation, monterey:       "bdafe57d1879fa7eb303b7f1854bf4b164c499de42d7b4817b897e93ebda70ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cd8ddc3984027818de62fd3391dd8f20c9f3db7d9007bd93dd1ae7144f92820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf2020ae0a36334762ad869c5d5a7f8b5d07172b41e79a9dd96ecd1760a134f3"
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
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
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