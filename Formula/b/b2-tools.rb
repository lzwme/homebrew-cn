class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/27/2c/1829421e891cddc63cd9317f8e53cc3f94dd649fd0828f268845b10d97c4/b2-3.11.0.tar.gz"
  sha256 "295a1cddf1fa809a4a53545ad9f19694c8458769d7e5e839194f3e8de46c2b9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdf5b6f02029e36510dc5e3f062247e62182160b0448c7dec569960b28d8aca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab9a023eabc8572c777791f31909166005c55ffa939dfe6acdfd96475601dfc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b62ff06a8f7c98a26c96e7f058d9d37fba320ca766b1cbe0a7c04cc27018c53"
    sha256 cellar: :any_skip_relocation, sonoma:         "a447d0713e7a6c517eedd9b9630c7c9595c45fb23198ba02576c199d9221d50a"
    sha256 cellar: :any_skip_relocation, ventura:        "7f7e5b010c887f5e39fc519b4d01d25d7e692af62507687f80d3085761c21aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "78509298d072789812a7cc847f2744772b25e83cdf9193a8664912244018f949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2ac9c9faf38580922483252b60fb68f42fca81b0ab63986f0f632160edae661"
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
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/89/81/ffd3998f719b9ccdeae3604ed85f190ebdee9af8ced388a203f5475024ec/b2sdk-1.24.1.tar.gz"
    sha256 "4e9f518edc9ba824b1075805657ae3c0d2789a6c25f8e593cd5c87776e7425ab"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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