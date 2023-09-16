class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/db/c5/e08a7aa42c962d34201151fa6b825fed7fbb998a1b612f37c7eb93a7e764/yt-dlp-2023.7.6.tar.gz"
  sha256 "cb58373869c8ccb5034746f91cfccd6d25ea697090dfd6f93e9034d51eb4aed2"
  license "Unlicense"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b33d0b31fa33f6b40b673d619535371fca2a260d7b003033af30976f514ae90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bda3b7ff3e1a21cdf3a6ae8ee74c619b1ded8eaf3c4c8bc27be8eadbcd53c61a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f4915e7a93536ce47a22aeb142a4e6e6bd8b65c59f6a8187c54519ad254222e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21f6d0153bd80dfab8b3bccd9a01479c7fa7e5a572f287b680fedc839afafbe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2df66b14e9defcb1bf18a9a594e6c2743de3dfc05589fc7ef54e915cba2f406d"
    sha256 cellar: :any_skip_relocation, ventura:        "50b4977a36a1bbe35376c8ff63a0938ef095175dd55033adf8a451a75b80d955"
    sha256 cellar: :any_skip_relocation, monterey:       "4242b28e5152b7e5cc8179852ea1420eb107136b6dabc56af9064f87f2a15244"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5a93f0baaac1a92fb552c5d2b5034019e9383596b2566086b4f8857686c9e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d02969e3d2453c145014e841d80e3da3003d109ee0828d0010fca27dda643c"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python-certifi"
  depends_on "python-mutagen"
  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
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