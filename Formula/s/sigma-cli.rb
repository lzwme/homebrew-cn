class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https:github.comSigmaHQsigma-cli"
  url "https:files.pythonhosted.orgpackages70e86a4e6aa2875494af43483a37c1715039d42a0ba54cb1353db5c3ebfded69sigma_cli-1.0.4.tar.gz"
  sha256 "30db40f7b6ea1cff8da5c03668ee37326fa371fa343129455741a6b8b68d81b2"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comSigmaHQsigma-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "0f116a1cdfabb9a8ab372cbfbc5a58bb55d010599cf04dcd72ad0b9ff8d14af5"
    sha256 cellar: :any,                 arm64_sonoma:  "5a0c149dee4040643ff7acaf2130a5597ac4663d7fdef750e523f4f5de337a85"
    sha256 cellar: :any,                 arm64_ventura: "739f2a3e06f36c606514719ef2f661881b4544ec526c4ade8f01ed61a2738ee9"
    sha256 cellar: :any,                 sonoma:        "2dd5b0ce7dd5a89f1e462aff4cc1a0dbfff5eb3235aa1c204a9fefbb9b7d4ce4"
    sha256 cellar: :any,                 ventura:       "ceab2cfd3fcef97866e246e0e8c5f87146da00fda05c0d9f7139d20384136299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6be7eabe41cc3119c7743d47cfe684b9315fbd265590cfeb8151d47a5fae535a"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "open-simh", because: "both install `sigma` binaries"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages3b8ade4dc1a6098621781c266b3fb3964009af1e9023527180cb8a3b0dd9d09eprettytable-3.12.0.tar.gz"
    sha256 "f04b3e1ba35747ac86e96ec33e3bb9748ce08e254dc2a1c6253945901beec804"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8cd5e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "pysigma" do
    url "https:files.pythonhosted.orgpackagesfc345d7bf067f4219f8634609ce30190ff51da96deb3ed6d675140a1a3c03601pysigma-0.11.18.tar.gz"
    sha256 "eb625590dbc9822bed9ad0d64cb42fb3df69581d98c0c87f674df255b1a617d7"
  end

  resource "pysigma-backend-sqlite" do
    url "https:files.pythonhosted.orgpackages7263e618d84f770f982afa5f8e99a93c99c48bd87992d1ba4cc961aab6ba15e9pysigma_backend_sqlite-0.2.0.tar.gz"
    sha256 "0ff1bbb0165477e938e2951808ba348bd29803fd3fae5c4cbcd117532e622217"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"sigma", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sigma version")

    output = shell_output("#{bin}sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}sigma plugin list --compatible")
    refute_match "Datadog Cloud SIEM backend", output
  end
end