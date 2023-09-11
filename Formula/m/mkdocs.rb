class Mkdocs < Formula
  include Language::Python::Virtualenv

  desc "Project documentation with Markdown"
  homepage "https://www.mkdocs.org/"
  url "https://files.pythonhosted.org/packages/35/6a/63612e19d9c903a608caf91fd2c1f07ccbb9610de4ddb6f187aec1cce197/mkdocs-1.5.2.tar.gz"
  sha256 "70d0da09c26cff288852471be03c23f0f521fc15cf16ac89c7a3bfb9ae8d24f9"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "249b5998c5d738de86911b237847392eed7595a0af74257bf5c0ce335a2f579f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ff8fec37e7ea3e796ca2b899ef7367e49c53ecef4016c0b8d614d9e43a41d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c541029e15c00fa6f47fb9f57290253586a1ac1d6c4efea65d79be8b145f4ef"
    sha256 cellar: :any_skip_relocation, ventura:        "d28d7e5dcfd94cd83d304c53fb7b3b2b9ebb222cd5267aefebb20160bb9f5ca0"
    sha256 cellar: :any_skip_relocation, monterey:       "21ebf8073ce196f7954d92899e69dffe68fa57733bd2a1478694f82c1ede929b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c6b374343347d3efd7ff9297575ed740557ca0e017668428c8f6d64fc91cfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b6fb23dee11ef2a58981ae3634769850427bb6f218eb6c7872d1bdefad1746"
  end

  depends_on "python-markdown"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/d9/29/d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4/ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml-env-tag" do
    url "https://files.pythonhosted.org/packages/fb/8e/da1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629c/pyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<~EOS
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<~EOS
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}/mkdocs", "build", "--clean"
  end
end