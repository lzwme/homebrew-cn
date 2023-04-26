class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https://commitizen-tools.github.io/commitizen/"
  url "https://files.pythonhosted.org/packages/d6/05/e99bf5855a35f81b5dd2dfcf8fd5af0e9c49e2ce602d9ea0be84ffc9382a/commitizen-3.1.0.tar.gz"
  sha256 "b09999c2a411ec5e9dbbb40aca43cff355e4a3da5f3dca69fbaed7a87d1559c2"
  license "MIT"
  head "https://github.com/commitizen-tools/commitizen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1744ff53caf99f271237283a5382935c0633af6400cc04467b180b78584fe09c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f750ca2ded573e9cd8dbdcc256327c44d7f9bb3ed25af2b3124c7338d7f2d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1961de6f8dd33c62a98a4105c380b27151953eef7361d925b661e6f413256ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "58a6983ceb3ef3ae48c9b6c84c0bd3403af3bb517b0171eb8440410dbff6c487"
    sha256 cellar: :any_skip_relocation, monterey:       "a8b55e7df33e89f019437a7dc78a2ebe73f52c930af553c08b7cefa03c189ad0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae08e67f2340c431ac204f1e24bea5e93007aac97f65a9c93d3d4b2e69e0c2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de449909dfe7e373097a86d97cdf1da23bf99dead9b44ccca8123c07b439956d"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/85/b9/e2bef848f79fce1e70d048b4de873424fde918c54ac2e6b8638cca887243/argcomplete-2.1.2.tar.gz"
    sha256 "fc82ef070c607b1559b5c720529d63b54d9dcf2dcfc2632b10e6372314a34457"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decli" do
    url "https://files.pythonhosted.org/packages/9f/30/064f53ca7b75c33a892dcc4230f78a1e01bee4b5b9b49c0be1a61601c9bd/decli-0.5.2.tar.gz"
    sha256 "f2cde55034a75c819c630c7655a844c612f2598c42c21299160465df6ad463ad"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/55/12/ab288357b884ebc807e3f4eff63ce5ba6b941ba61499071bf19f1bbc7f7f/importlib_metadata-4.13.0.tar.gz"
    sha256 "dd0173e8f150d6815e098fd354f6414b0f079af4644ddfe90c71e2fc6174346d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/04/c6/a8dbf1edcbc236d93348f6e7c437cf09c7356dd27119fcc3be9d70c93bb1/questionary-1.10.0.tar.gz"
    sha256 "600d3aefecce26d48d97eee936fdb66e4bc27f934c3ab6dd1e292c4f43946d90"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generates a changelog after an example commit
    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "yes | #{bin}/cz commit"
    system "#{bin}/cz", "changelog"

    # Verifies the checksum of the changelog
    expected_sha = "97da642d3cb254dbfea23a9405fb2b214f7788c8ef0c987bc0cde83cca46f075"
    output = File.read(testpath/"CHANGELOG.md")
    assert_match Digest::SHA256.hexdigest(output), expected_sha
  end
end