class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https:github.comyt-dlpyt-dlp"
  url "https:files.pythonhosted.orgpackages93f08d894dd24447945269d123f6a061520103fb790211c6846418c6ee1065ffyt-dlp-2023.11.16.tar.gz"
  sha256 "f0ccdaf12e08b15902601a4671c7ab12906d7b11de3ae75fa6506811c24ec5da"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e492c0fe0dd6fc6b898cc9acb50b3f345da3dd38d2cb63b21196ab130b05e2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0559dd8febc7ca17981fb4ad38ffd914b9b65b822abf9b5083af687e0350ed5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0879a05b4aca935a0f625cd0e57f1d387682cba91cef7da8a96fb57956b9243d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f011cc8e8ad166232e9757df213142649110ed6395ea3435a86e1059ef36b049"
    sha256 cellar: :any_skip_relocation, ventura:        "a96c137da6c44ba246e4326858de8e7253f30477d9276d937c06744185ffbc6a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f79c097a0022dbcbfa3c7204b42e78ea08da0e516197da9fab7774d4458c7d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19935f8171eec54b837b902ba123db6df12ad4f981e76cfeecf43a237fd4b337"
  end

  head do
    url "https:github.comyt-dlpyt-dlp.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "python-brotli"
  depends_on "python-certifi"
  depends_on "python-mutagen"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages14c909d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e627a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def install
    system "make", "pypi-files" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec"sharemanman1yt-dlp.1"
    bash_completion.install libexec"sharebash-completioncompletionsyt-dlp"
    zsh_completion.install libexec"sharezshsite-functions_yt-dlp"
    fish_completion.install libexec"sharefishvendor_completions.dyt-dlp.fish"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}yt-dlp", "--simulate", "https:www.youtube.comwatch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}yt-dlp", "--simulate", "--yes-playlist", "https:www.youtube.comwatch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end