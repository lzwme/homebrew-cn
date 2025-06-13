class Twine < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https:github.compypatwine"
  url "https:files.pythonhosted.orgpackagesc8a26df94fc5c8e2170d21d7134a565c3a8fb84f9797c1dd65a5976aaf714418twine-6.1.0.tar.gz"
  sha256 "be324f6272eff91d07ee93f251edf232fc647935dd585ac003539b42404a8dbd"
  license "Apache-2.0"
  revision 1
  head "https:github.compypatwine.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f267e6bc99b970880cb5a16ce31af3225a018f03f6ec7c0932477edbc5ab973c"
    sha256 cellar: :any,                 arm64_sonoma:  "f96b176ea05a893e4b676117773e90fdeefc7a419e582fb45b643241a57cb748"
    sha256 cellar: :any,                 arm64_ventura: "ee062b8566a05d13a21be21b7730ebfa79c162ab1f1c39d3c4eae9fccf4945e9"
    sha256 cellar: :any,                 sonoma:        "2ce96b6f672b568ccacb2050d0929f08492a023756cc0165bfe4c73e67796941"
    sha256 cellar: :any,                 ventura:       "498764326f10538107c289332277ac570b269c2daf4077fce1ae72ad64823d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc0cc2793ba0f7e5f6ccc4ee1d7f09cc797e2f6a5bfa96f584fdf53c38b0aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e780a1a9ab1c20d469849cc977a515a3dd58c02ed719eaa074ba7bd4dcd3d796"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "id" do
    url "https:files.pythonhosted.orgpackages2211102da08f88412d875fa2f1a9a469ff7ad4c874b0ca6fed0048fe385bdb3did-1.5.0.tar.gz"
    sha256 "292cb8a49eacbbdbce97244f47a97b4c62540169c976552e497fd57df0734c1d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackagesdfadf3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages7009d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37dkeyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "nh3" do
    url "https:files.pythonhosted.orgpackages37302f81466f250eb7f591d4d193930df661c8c23e9056bdc78e365b646054d8nh3-0.2.21.tar.gz"
    sha256 "4990e7ee6a55490dbf00d61a6f476c9a3258e31e711e13713b2ea7d6616f670e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "readme-renderer" do
    url "https:files.pythonhosted.orgpackages5aa9104ec9234c8448c4379768221ea6df01260cd6c2ce13182d4eac531c8342readme_renderer-44.0.tar.gz"
    sha256 "8712034eabbfa6805cacf1402b4eeb2a73028f72d1166d6f5cb7f9c047c5d1e1"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rfc3986" do
    url "https:files.pythonhosted.orgpackages85401520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources

    pkgshare.install "testsfixturestwine-1.5.0-py2.py3-none-any.whl"
  end

  test do
    wheel = "twine-1.5.0-py2.py3-none-any.whl"
    cmd = "#{bin}twine upload -uuser -ppass #{pkgshare}#{wheel} 2>&1"
    assert_match(Uploading.*#{wheel}.*HTTPError: 403m, shell_output(cmd, 1))
  end
end