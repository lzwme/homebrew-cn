class Molecule < Formula
  include Language::Python::Virtualenv

  desc "Automated testing for Ansible roles"
  homepage "https://molecule.readthedocs.io"
  url "https://files.pythonhosted.org/packages/a0/26/bfeca24fbfbdf12be51a8cc25f51585b47a972162f392737bc909f40f763/molecule-25.1.0.tar.gz"
  sha256 "d3d3346465e3e4cf8614db6b083e352b65c76bbe05e511af85fbf42f5950adde"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ab0f85806365c8ef0230553ba5a76e17b30991899ac86c123300aee6dd7d016"
    sha256 cellar: :any,                 arm64_sonoma:  "852fb9b7c7938180c741fc72638d0ce0331aa2bbd1db5ea576a09ae18058f5a2"
    sha256 cellar: :any,                 arm64_ventura: "5a8064fd5159107f4fbc082c7d416c7ceb2034df485fcdc38726e1d1f0989e9f"
    sha256 cellar: :any,                 sonoma:        "523af8f6dcc1e3072219092772a5dccf1c5641b2b33f64e8080ed10368f8a186"
    sha256 cellar: :any,                 ventura:       "3dea6a9559f3a0354126d3b28e6b590fe3558b31574285c0c82ad06bbde39db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f664492795f6e6ffefba0220e5b7baa464e8c4a59ae19530fa0990ef6f5988"
  end

  depends_on "rust" => :build
  depends_on "ansible"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "gmp"
  end

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/59/f9/c48f3a140e3afad144a720f5c29aa8b34087926b2e2fc8778d4d4b5b6323/ansible_compat-24.10.0.tar.gz"
    sha256 "0ad873e0dae8b2de79bc33ced813d6c92c716c4d7b82f9a4693e1fd57f43776e"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/42/46/15836f1f48e2682bd5d04f7b3e2cb27e17626bec3cd7a4f2a7b0ccefbbd2/ansible_core-2.18.1.tar.gz"
    sha256 "14cac1f92bbdae881cb0616eddeb17925e8cb507e486087975e724533d9de74f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/48/c8/6260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045/attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/d6/6c/57418c4404cd22fe6275b8301ca2b46a8cdaa8157938017a9ae0b3edf363/bracex-2.5.post1.tar.gz"
    sha256 "12c50952415bfa773d2d9ccb8e79651b8cdb1f31a42f6091b804f6ba2b4a66b6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-help-colors" do
    url "https://files.pythonhosted.org/packages/6f/50/76f51d9c7fcd72a12da466801f7c1fa3884424c947787333c74327b4fcf3/click-help-colors-0.9.4.tar.gz"
    sha256 "f4cabe52cf550299b8888f4f2ee4c5f359ac27e33bcfe4d61db47785a5cc936c"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/c5/e6/d1f6c00b7221e2d7c4b470132c931325c8b22c51ca62417e300f5ce16009/docker-pycreds-0.4.0.tar.gz"
    sha256 "6ce3270bcaf404cc4c3e27e4b6c70d3521deae82fb508767870fdbf772d584d4"
  end

  resource "enrich" do
    url "https://files.pythonhosted.org/packages/bb/77/cb9b3d6f2e2e5f8104e907ea4c4d575267238f52c51cf9f864b865a99710/enrich-1.2.7.tar.gz"
    sha256 "0a2ab0d2931dff8947012602d1234d2a3ee002d9a355b5d70be6bf5466008893"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "molecule-vagrant" do
    url "https://files.pythonhosted.org/packages/c9/ad/0ed60a69cd6887622ff03d67beacbc54183f9d6fa45978c37dc35a315b30/molecule-vagrant-2.0.0.tar.gz"
    sha256 "bb27f4ec482d0f68231f31136bfba328fc8ef7d81341874284bdd71295e278d5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/2b/3f/2e42a44c9705d72d9925fe8daf00f31bcf82e8b84ec5a752a8a1357c3ef8/python-vagrant-1.0.0.tar.gz"
    sha256 "a8fe93ccf2ff37ecc95ec2f49ea74a91a6ce73a4db4a16a98dd26d397cfd09e5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/27/32/fd98246df7a0f309b58cae68b10b6b219ef2eb66747f00dfb34422687087/referencing-0.36.1.tar.gz"
    sha256 "ca2e6492769e3602957e9b831b94211599d2aade9477f5d44110d2530cf9aade"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ce/10/f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6/resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/01/80/cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfd/rpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "selinux" do
    url "https://files.pythonhosted.org/packages/25/07/51acd62e1e15e1172d46f7e32faf138725b147f8c08dbf2d512159d7a310/selinux-0.3.0.tar.gz"
    sha256 "2a88b337ac46ad0f06f557b2806c3df62421972f766673dd8bf26732fb75a9ea"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/41/ab/b3a52228538ccb983653c446c1656eddf1d5303b9cb8b9aef6a91299f862/wcmatch-10.0.tar.gz"
    sha256 "e72f0de09bba6a04e0de70937b0cf06e55f36f37b3deb422dfaf854b867b840a"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  def python3
    "python3.13"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"molecule", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    ENV["ANSIBLE_REMOTE_TMP"] = testpath/"tmp"
    ENV["ANSIBLE_PYTHON_INTERPRETER"] = which(python3)
    # Test the Vagrant driver
    system bin/"molecule", "init", "scenario", "acme.foo_vagrant", "--driver-name",
                           "vagrant", "--provisioner-name", "ansible"
    assert_predicate testpath/"molecule/acme.foo_vagrant/molecule.yml", :exist?,
                     "Failed to create 'molecule/acme.foo_vagrant/molecule.yml' file!"
    output = shell_output("#{bin}/molecule list --format yaml").chomp
    assert_match "Scenario Name: acme.foo_vagrant", output
  end
end