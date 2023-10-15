class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/db/7f/8bdf5c78fc01a71f1babcc813b972996144b46ee88394356f4a188686db5/yt-dlp-2023.10.13.tar.gz"
  sha256 "e026ea1c435ff36eef1215bc4c5bb8c479938b90054997ba99f63a4541fe63b4"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b78f82979048b864934154542dcfd191b642e015d0e36530b0e051f2ebfbf089"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c0e98a023a9c7e75e508939306e102eca06aaf14c5b50515b2a3332f283caf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ce0ecd50059dff5cd803ed0e4540deef7874876d30fc5e3458507f366bc9946"
    sha256 cellar: :any_skip_relocation, sonoma:         "d227f968503ef119fd065bea945203b018dc2b20a34dd911a271e520164b4988"
    sha256 cellar: :any_skip_relocation, ventura:        "4122cbb62347515e666740f36b9b8466a6696e45949eda0f01dfc08e537d5214"
    sha256 cellar: :any_skip_relocation, monterey:       "9da4b43707bd6777c50cce4af958e2544aa2f49f74e5336686365459daef6178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6069715de6c86fcef653db70c05c10e6f422d92215f88a2bd67b344442598a72"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python-certifi"
  depends_on "python-mutagen"
  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/c9/09d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53/pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
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