class Safety < Formula
  include Language::Python::Virtualenv

  desc "Checks Python dependencies for known vulnerabilities and suggests remediations"
  homepage "https:safetycli.comproductsafety-cli"
  url "https:files.pythonhosted.orgpackagesbff60569f2928e03b7058c95f4ae05d3098c9c0ba0d42de2adfe91fd6de25c2esafety-3.2.11.tar.gz"
  sha256 "70a3b7cc75ba41907bf1705bcbbeab232688657c21088e108712ecb601fe0f20"
  license "MIT"
  head "https:github.compyupiosafety.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05bce5e7d178b074e3d1358b98450ea886cd462829cebb08a97931fa03b15836"
    sha256 cellar: :any,                 arm64_sonoma:  "eeae21e7fb7b6a1c90b47bf67664ca734f5b60c9b057f8965f0ba227c9f72ae7"
    sha256 cellar: :any,                 arm64_ventura: "5c9e24a9bb2832d6f4d0c69b247e50ad4b0d7d9e2b6ce33f6a15e2f901867660"
    sha256 cellar: :any,                 sonoma:        "40cfa117866379f45b25f03db5d722e895cf9eb231bde956f5929512278e59cf"
    sha256 cellar: :any,                 ventura:       "cd856083121ea9639821b67cbb3524dc15cca0b5806160dbf9404d6063fb7201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfc47f4d98c6337eaedd631f730139531f021d05b0592bb0d9bcf2baf60b27f"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "authlib" do
    url "https:files.pythonhosted.orgpackagesf37547dbab150ef6f9298e227a40c93c7fed5f3ffb67c9fb62cd49f66285e46eauthlib-1.3.2.tar.gz"
    sha256 "4b16130117f9eb82aa6eec97f6dd4673c3f960ac0283ccdae2897ee4bc030ba2"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dparse" do
    url "https:files.pythonhosted.orgpackages29ee96c65e17222b973f0d3d0aa9bad6a59104ca1b0eb5b659c25c2900fccd85dparse-0.6.4.tar.gz"
    sha256 "90b29c39e3edc36c6284c82c4132648eaf28a01863eb3c231c2512196132201a"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagesd571bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackages6d3014d8609f65c8aeddddd3181c06d2c9582da6278f063b27c910bbf9903441marshmallow-3.23.1.tar.gz"
    sha256 "3a8dfda6edd8dcdbf216c0ede1d1e78d230a6dc9c5a088f58c4083b974a0d468"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "safety-schemas" do
    url "https:files.pythonhosted.orgpackages074889f164c0fcb41d8cb4a67580461f94d6e3cb0fff7b198fb0c3bbb7bdfd4asafety_schemas-0.0.9.tar.gz"
    sha256 "23044f88aa21213980b00e6002cf56229e1efc2b6cbdde3e90fc781ca6bbc217"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagese273c1ccf3e057ef6331cc6861412905dc218203bde46dfe8262c1631aa7fb11setuptools-75.4.0.tar.gz"
    sha256 "1dc484f5cf56fd3fe7216d7b8df820802e7246cfb534a1db2aa64f14fcb9cdcb"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagese7879eb07fdfa14e22ec7658b5b1147836d22df3848a22c85a4e18ed272303a5typer-0.13.0.tar.gz"
    sha256 "f1c7198347939361eec90139ffa0fd8b3df3a2259d5852a0f7400e476d95985c"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(bin"safety --version")

    assert_match "Safety is not authenticated, please first authenticate and try again.",
      shell_output(bin"safety check-updates", 1)
  end
end