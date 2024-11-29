class CoboCli < Formula
  include Language::Python::Virtualenv

  desc "Cobo Command-line Tool"
  homepage "https:github.comCoboGlobalcobo-cli"
  url "https:files.pythonhosted.orgpackages83e7dc47cd582b8f68546bac444b79a27d48b297b3d7c74cc9edb38e99c22a1acobo_cli-0.0.4.tar.gz"
  sha256 "db66874dc6755d51c0efe82af01c273f733e005b9cbe7e5dd66c62b39a3cd469"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2ae7c31ff657e9a59e521f1935b3c0a5cccdd8e35210c82ea90e0db677b2223"
    sha256 cellar: :any,                 arm64_sonoma:  "9f9e0c695a8193f990db05baa5d8259fb8dec13916eaa67ccf52fe28c1d8b2ff"
    sha256 cellar: :any,                 arm64_ventura: "7780fbaf1554d58f017e77ae9446f149f9f69a43a37534fe76a86463be1a1914"
    sha256 cellar: :any,                 sonoma:        "1dd991514407b8416a8bd03a0723b10c7c2c535288fc79069784b8996023a2f6"
    sha256 cellar: :any,                 ventura:       "3ffba56d9a102ec3a3ca2500d0c9f110ac406a4e9b4d1252ab9575927262f3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c5698330c5560ff41e168dc63b4fe56b23f06b9f0463a698134052f5f623e21"
  end

  depends_on "certifi"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "rust"

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackagesfc97c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90dcffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dataclasses-json" do
    url "https:files.pythonhosted.orgpackages64a4f71d9cf3a5ac257c993b5ca3f93df5f7fb395c725e7f1e6479d2514173c3dataclasses_json-0.6.7.tar.gz"
    sha256 "b6b3e528266ea45b9535223bc53ca645f5208833c29229e847b3f26a1cc55fc0"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "email-validator" do
    url "https:files.pythonhosted.orgpackages48ce13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackages6d3014d8609f65c8aeddddd3181c06d2c9582da6278f063b27c910bbf9903441marshmallow-3.23.1.tar.gz"
    sha256 "3a8dfda6edd8dcdbf216c0ede1d1e78d230a6dc9c5a088f58c4083b974a0d468"
  end

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackages98a41ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3fmypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages4186a03390cb12cf64e2a8df07c267f3eb8d5035e0f9a04bb20fb79403d2a00epydantic-2.10.2.tar.gz"
    sha256 "2bc2d7f17232e0841cbba4641e65ba1eb6fafb3a08de3a091ff3ce14a197c4fa"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesa69f7de1f19b6aea45aeb441838782d68352e71bfa98ee6fa048d5041991b33epydantic_core-2.27.1.tar.gz"
    sha256 "62a763352879b84aa31058fc931884055fd75089cccbd9d58bb6afd01141b235"
  end

  resource "pydantic-settings" do
    url "https:files.pythonhosted.orgpackagesb5d49dfbe238f45ad8b168f5c96ee49a3df0598ce18a0795a983b419949ce65bpydantic_settings-2.6.1.tar.gz"
    sha256 "e0f92546d8a9923cb8941689abf85d6601a8c19a23e97a34b2964a2e3f813ca0"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackages1887302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4fftomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackagesd419b65f1a088ee23e37cdea415b357843eca8b1422a7b11a9eee6e35d4ec273tomli_w-1.1.0.tar.gz"
    sha256 "49e847a3a304d516a169a601184932ef0f6b61623fe680f836a2aa7128ed0d33"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "typing-inspect" do
    url "https:files.pythonhosted.orgpackagesdc741789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264atyping_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Available webhook event types:", shell_output("#{bin}cobo webhook events")

    assert_match version.to_s, shell_output("#{bin}cobo version")
  end
end