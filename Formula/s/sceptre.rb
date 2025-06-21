class Sceptre < Formula
  include Language::Python::Virtualenv

  desc "Build better AWS infrastructure"
  homepage "https:docs.sceptre-project.org"
  url "https:files.pythonhosted.orgpackages320be3249a42ab6cab8cf9e2c5261a95740daa0b74edf1aaecf5c17293e67784sceptre-4.5.3.tar.gz"
  sha256 "84ebc52b59e980b5d25926bbe7116edfbe428dd34ef47014e7f3b200136dc7a0"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cef0955107942bcc6b6c98c3e6948848de0eca717110fa16830378fdcb6efc8"
    sha256 cellar: :any,                 arm64_sonoma:  "c5b8379dacb404e7c286a27289d512a809f66f0bf18475b4774a602a54076be9"
    sha256 cellar: :any,                 arm64_ventura: "ef53c96dfd02eaa96a11f239b9ba05ca1788ac53ec927c6e61b0694c94553808"
    sha256 cellar: :any,                 sonoma:        "474a38aa7eba4c81343d6fe5885fb5609cbba50468c0c3d50f527cbe5095de91"
    sha256 cellar: :any,                 ventura:       "9be5b62ead5267746495821bee882dce883e17d04549c27f72d9bec54638f166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96025b896fbb351b0db9298733c63971d07fc16e2ba510ab8d9fb9ff44e4fff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989daa64fd40d9f2de6e3862ac41346d1ee1238edef951ebc9787a1619ca4c22"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages5a66a26e7f20039ae3c57524baf26af43216c3959013f23308458f211cce78a5boto3-1.38.40.tar.gz"
    sha256 "fcef3e08513d276c97d72d5e7ab8f3ce9950170784b9b5cf4fab327cdb577503"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages612342cc861466a34e45bd1783c3b3a547d5f723a8d21f6151cd1e3d84adfba6botocore-1.38.40.tar.gz"
    sha256 "aefbfe835a7ebe9bbdd88df3999b0f8f484dd025af4ebb3f3387541316ce4349"
  end

  resource "cfn-flip" do
    url "https:files.pythonhosted.orgpackagesca758eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackages8275f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12dcolorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "deepdiff" do
    url "https:files.pythonhosted.orgpackages0a0f9cd2624f7dcd755cbf1fa21fb7234541f19a1be96a56f387ec9053ebe220deepdiff-8.5.0.tar.gz"
    sha256 "a4dd3529fa8d4cd5b9cbb6e3ea9c95997eaa919ba37dac3966c1b8f872dc1cd1"
  end

  resource "deprecation" do
    url "https:files.pythonhosted.orgpackages5ad38ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages6911a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages97ae7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "orderly-set" do
    url "https:files.pythonhosted.orgpackages034a38030da31c13dcd5a531490006e63a0954083fb115113be9393179738e25orderly_set-5.4.1.tar.gz"
    sha256 "a1fb5a4fdc5e234e9e8d8e5c1bbdbc4540f4dfe50d12bf17c8bc5dbf1c9c878d"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "sceptre-cmd-resolver" do
    url "https:files.pythonhosted.orgpackages6580acb986323af0b3e5e3eb59bb293e6671cdc43ded91620a24a1a58b2e28f7sceptre-cmd-resolver-2.0.0.tar.gz"
    sha256 "155c47e2f4f55c7b6eb64bfe8760174701442ecaddba1a6f5cb7715a1c95be99"
  end

  resource "sceptre-file-resolver" do
    url "https:files.pythonhosted.orgpackages3620c8162b958668c741bef1d7d247a78f796b705ed0eec72501ef308110923bsceptre-file-resolver-1.0.6.tar.gz"
    sha256 "d47cfe32d141fb46467fcd319bf4386f0178cf0c2211c6f1d2dffbc80d785a6d"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    # Avoid issue if `numpy` is installed, https:github.comSceptresceptreissues1541
    virtualenv_install_with_resources(system_site_packages: false)

    generate_completions_from_executable(bin"sceptre", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    system bin"sceptre", "--help"
  end
end