class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/5e/da/a83310e00ebe92ce18d1a09bf11ba9b6c8425242e2eb78f43ce12784820f/b2-3.10.1.tar.gz"
  sha256 "48cf8270641e35a50e9fb06d98c7b64db0d45d7df3550e9549eb1dbc3cbc2b31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10eee4172cf5c7b164cbe3fe55ae448d2db90e266ca48ed930225c2b10e96a72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d158f9c5579cd920863f1dc2ff8e7d6815e61c837a0c92067e8bcfeb1eedda33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "692e99099392909e2b6c2dba1b1b33e783b77b758616ff24992b8999115b9290"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf206464bdb11fe0ef06f51f3312690432437d30aa348d2108c91495367e5bb0"
    sha256 cellar: :any_skip_relocation, ventura:        "ca0920db2b5ef6d75e8a3030648890f690fdc9f27e401b53d91464b673de69ec"
    sha256 cellar: :any_skip_relocation, monterey:       "2d0a78c326b7710059fd88fc397019c3de77784bae7ca97f3e929749adf0caf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ac666ea963ccc9e3fba1902c438905e51bd93323a2f91bb59a3e6c1f639c32"
  end

  depends_on "docutils"
  depends_on "python-certifi"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
    sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/89/81/ffd3998f719b9ccdeae3604ed85f190ebdee9af8ced388a203f5475024ec/b2sdk-1.24.1.tar.gz"
    sha256 "4e9f518edc9ba824b1075805657ae3c0d2789a6c25f8e593cd5c87776e7425ab"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/e7/9f/5a7a4d4c414b074df216824068cf8d82a05f05829e11976217cb9e550f50/phx-class-registry-4.0.6.tar.gz"
    sha256 "66e9818de0a9d62e8cfe311587fcd3853ba941b71c11a7a73e5808d6550db125"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/06/04/e65e7f457ce9a2e338366a3a873ec6994e081cf4f99becb59ab6ce19e4b5/tqdm-4.65.2.tar.gz"
    sha256 "5f7d8b4ac76016ce9d51a7f0ea30d30984888d97c474fdc4a4148abfb5ee76aa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
  end

  def install
    virtualenv_install_with_resources

    system bin/"b2", "install-autocomplete", "--shell", "bash"
    bash_completion.install "#{Dir.home}/.bash_completion.d/b2"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    assert_match "-F _python_argcomplete b2",
                 shell_output("bash -c \"source #{bash_completion}/b2 && complete -p b2\"")
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end