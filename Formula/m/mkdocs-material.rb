class MkdocsMaterial < Formula
  include Language::Python::Virtualenv
  desc "Material Design theme for MkDocs"
  homepage "https:squidfunk.github.iomkdocs-material"
  url "https:github.comsquidfunkmkdocs-materialarchiverefstags9.5.41.tar.gz"
  sha256 "c15129c3f46e60da0651206ce7934c2972b45933d1828583f36ca1fdced7a1a2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3be6f33ed9b354579c1f65cf08d9f84c2743f606c8288314b22558553fd70911"
    sha256 cellar: :any,                 arm64_sonoma:  "98e65593b22fb106c761957e812ff0070d24fa23e6a4186ee615dea35a212b83"
    sha256 cellar: :any,                 arm64_ventura: "3f18cfc94e115d310764bd4113bd2667d59dd8a00424e28286a10ce20a6a3259"
    sha256 cellar: :any,                 sonoma:        "bd4eeb53d6c8a417d2f10ea7ad28ccc88e8ba573ae91ef801e4c0c5caae98ba7"
    sha256 cellar: :any,                 ventura:       "2cd091cea092041124553616077a7c753b54cdb74c25b58dcdd07a51d07915ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2a0528d808a77645f6127c4850d81f27ee99d092a880e22868502d9fae2933"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "mkdocs", because: "both install `mkdocs` binaries"

  resource "mkdocs" do
    url "https:files.pythonhosted.orgpackagesbcc6bbd4f061bd16b378247f12953ffcb04786a618ce5e904b8c5a01a0309061mkdocs-1.6.1.tar.gz"
    sha256 "7b432f01d928c084353ab39c57282f29f92136665bdd6abf7c1ec8d822ef86f2"
  end

  resource "babel" do
    url "https:files.pythonhosted.orgpackages2a74f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagesb0ee9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ghp-import" do
    url "https:files.pythonhosted.orgpackagesd929d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "Jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "Markdown" do
    url "https:files.pythonhosted.orgpackages54283af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "MarkupSafe" do
    url "https:files.pythonhosted.orgpackagesb4d238ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8fmarkupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "mkdocs-get-deps" do
    url "https:files.pythonhosted.orgpackages98f5ed29cd50067784976f25ed0ed6fcd3c2ce9eb90650aa3b2796ddf7b6870bmkdocs_get_deps-0.2.0.tar.gz"
    sha256 "162b3d129c7fad9b19abfdcb9c1458a651628e4b1dea628ac68790fb3061c60c"
  end

  resource "mkdocs-material-extensions" do
    url "https:files.pythonhosted.orgpackages799b9b4c96d6593b2a541e1cb8b34899a6d021d208bb357042823d4d2cabdbe7mkdocs_material_extensions-1.3.1.tar.gz"
    sha256 "10c9511cea88f568257f960358a467d12b970e1f7b2c0e5fb2bb48cab1928443"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "paginate" do
    url "https:files.pythonhosted.orgpackagesec4668dde5b6bc00c1296ec6466ab27dddede6aec9af1b99090e1107091b3b84paginate-0.5.7.tar.gz"
    sha256 "22bd083ab41e1a8b4f3690544afb2c60c25e5c9a63a30fa2f483f6c60c8e5945"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "Pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pymdown-extensions" do
    url "https:files.pythonhosted.orgpackagesf4712730a20e9e3752393d78998347f8b1085ef9c417646ea9befbeef221e3c4pymdown_extensions-10.11.2.tar.gz"
    sha256 "bc8847ecc9e784a098efd35e20cba772bc5a1b529dfcef9dc1972db9021a1049"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "PyYAML" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyyaml-env-tag" do
    url "https:files.pythonhosted.orgpackagesfb8eda1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629cpyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "watchdog" do
    url "https:files.pythonhosted.orgpackagesa248a86139aaeab2db0a2482676f64798d8ac4d2dbb457523f50ab37bf02ce2cwatchdog-5.0.3.tar.gz"
    sha256 "108f42a7f0345042a854d4d0ad0834b741d421330d5f575b81cb27b883500176"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
    bin.install_symlink libexec"binmkdocs"
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath"mkdocs.yml").write <<~YAML
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: material
    YAML
    mkdir testpath"docs"
    (testpath"docsindex.md").write <<~MARKDOWN
      # A heading

      And some deeply meaningful prose.
    MARKDOWN
    system bin"mkdocs", "build", "--clean"
  end
end