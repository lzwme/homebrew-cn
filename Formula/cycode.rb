class Cycode < Formula
  include Language::Python::Virtualenv

  desc "Boost software development security via secret scanning, SAST, SCA, and IaC"
  homepage "https://github.com/cycodehq-public/cycode-cli"
  url "https://files.pythonhosted.org/packages/f1/29/5225ef43f33e036a01f11a236c66f9247a6ec45c04177692a7ea6de42ee5/cycode-1.0.0.tar.gz"
  sha256 "f5740497337504b167d6d8e976f300dbb67cc3de0d123ef64ff7778016902029"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca709debdbe383ee1a94251c02f88c8f4ece3971e20ee2c36d21c6053b7ce59b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c1d06f253441bf60c352ee6eb25e1779eb3af3b73a4dde3c2097c9be228e352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23ad8966b52ccdde2168f9bca57f1c25129fd7db498954905e12a3a97a19404b"
    sha256 cellar: :any_skip_relocation, ventura:        "f7dca0bce0670924ff41d8dda180df6be83714ada947bbcfed47948e92a59682"
    sha256 cellar: :any_skip_relocation, monterey:       "9b356653e36360dce57688ca2adbcf71b20a5c0771675c755c4f35ec0e1b938e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f358d6a05819629776f99a6e07036cdf9e70dc9178d77b845609d815e279f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e8157a20e64c205c1bcf9cc0a79129b279161110be350dd3322ddcee18bd58"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/ec/74/1cf2d9912921cebdba3fa954949206c8aa159c9cc803b88140fb227f8a0e/arrow-0.17.0.tar.gz"
    sha256 "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/87/56/6dcdfde2f3a747988d1693100224fb88fc1d3bbcb3f18377b2a3ef53a70a/GitPython-3.1.32.tar.gz"
    sha256 "8d9b8cb1e80b9735e8717c9362079d3ce4c6e5ddeebedd0361b228c3a67a62f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/3b/34/cd19aa2e9b03ea3a4c8d3c5803f7550cf87e294f602cd9ac5679d5466c52/marshmallow-3.8.0.tar.gz"
    sha256 "47911dd7c641a27160f0df5fd0fe94667160ffe97f70a42c3cc18388d86098cc"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/e4/84/4686ee611bb020038375c5f11fe7b6b3bb94ee78614a1faba45effe51591/texttable-1.6.7.tar.gz"
    sha256 "290348fb67f7746931bcdfd55ac7584ecd4e5b0846ab164333f0794b121760f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Error: ignore by type is missing", shell_output("#{bin}/cycode ignore 2>&1", 1)
    assert_match "Error: Cycode client id needed.", shell_output("#{bin}/cycode scan path 2>&1", 1)
    output = shell_output("#{bin}/cycode scan -t test 2>&1", 2)
    assert_match "Error: Invalid value for '--scan-type' / '-t'", output
    assert_equal "Cycode authentication failed", shell_output("#{bin}/cycode auth check").strip
    assert_match version.to_s, shell_output("#{bin}/cycode version")
  end
end