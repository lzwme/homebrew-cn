class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/09/68/e938aec15c204e3c55db570598409fe6bbd81fb81e26616b4b23d96ea92c/copier-9.9.1.tar.gz"
  sha256 "244bdf3ec5eb460dbe45ef22b825e9897b0bcc9d94ca96dad3ced3d786cfeab7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4ab5a597d253b10f000e3d1fbcf49108d937e8bad4885a29153a281d3a07919"
    sha256 cellar: :any,                 arm64_sonoma:  "d01dc5048fb394923d74cada9f334d0873bc30287a14b4aa936b19a24984bf56"
    sha256 cellar: :any,                 arm64_ventura: "c0dfae958e74407c5b298557a2d320b42f101e9ec3cc895c9c031bcb82a6084e"
    sha256 cellar: :any,                 sonoma:        "40daaafb7552a6e901a23dd0211f168ba158809fcb0e44538fbcec81bcf9ca1f"
    sha256 cellar: :any,                 ventura:       "b3fd8b9b6ef5e15a55fa4a4975cd6b89b177173aa98e1338e18cdfd2182aeaf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476b6a62452fe0d845e5877a655a0dcba2b690930293d5dcdc49168138d49b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ff7f72f05ab7e5946b6b22ff56dc4ddef1229f9dad946e7ec904332649b5f0"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/f1/2f/194d9a34c4d831c6563d2d990720850f0baef9ab60cb4ad8ae0eff6acd34/dunamai-1.25.0.tar.gz"
    sha256 "a7f8360ea286d3dbaf0b6a1473f9253280ac93d619836ad4514facb70c0719d1"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jinja2-ansible-filters" do
    url "https://files.pythonhosted.org/packages/1a/27/fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7/jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/f0/5d/49ba324ad4ae5b1a4caefafbce7a1648540129344481f2ed4ef6bb68d451/plumbum-1.9.0.tar.gz"
    sha256 "e640062b72642c3873bd5bdc3effed75ba4d3c70ef6b6a7b907357a84d909219"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/a8/b8/d16eb579277f3de9e56e5ad25280fab52fc5774117fb70362e8c2e016559/questionary-2.1.0.tar.gz"
    sha256 "6302cdd645b19667d8f6e6634774e9538bfcd1aad9be287e743d96cacaf95587"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin/"copier", "copy", *params, "--vcs-ref=v0.1.0",
      "https://github.com/copier-org/autopretty.git", "template"
    assert (testpath/"template").directory?
    assert_path_exists testpath/"template/.copier-answers.autopretty.yml"
  end
end