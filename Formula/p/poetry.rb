class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https:python-poetry.org"
  url "https:files.pythonhosted.orgpackagesdb121c8d8b2c6017a33a9c9c708c6d2bb883af7f447520a466dc21d2c74ecfe1poetry-2.1.3.tar.gz"
  sha256 "f2c9bd6790b19475976d88ea4553bcc3533c0dc73f740edc4fffe9e2add50594"
  license "MIT"
  revision 2
  head "https:github.compython-poetrypoetry.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc9f7200f3f721790cca4a2542152fa19cf0f9dcc837ebe88dc535142ff15b43"
    sha256 cellar: :any,                 arm64_sonoma:  "6bdfeaf69174b39789c2a1889e0472729eb573b5023ad97bfb32580431a13424"
    sha256 cellar: :any,                 arm64_ventura: "b793a432eb1b67f683fd3c43b763b08bb452df52662c22cc11af9a9fcf11db97"
    sha256 cellar: :any,                 sonoma:        "b7d1e5de6d01a056676d2215d44e6a6f75db823d20f23ab9c54a69010ffa98d4"
    sha256 cellar: :any,                 ventura:       "a6d956db4fe0b661e6f10b2dac7048e86c2b8d8f97048a0ab4d87ed603da8d03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a94e1eb07e0bea206bed1b19e3898f03a42251a86c4ee61cf8db5d9d612d9ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e0a36d6371e00a234a12851b105c2e5756c78e5b984b9c62ed03a4ce127fb7"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "ninja" => :build # for rapidfuzz
  depends_on "python-setuptools" => :build # for zstandard to bypass build isolation
  depends_on "certifi"
  depends_on "cffi"
  depends_on "python@3.13"
  depends_on "zstd"

  uses_from_macos "libffi"

  on_linux do
    depends_on "cryptography"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "build" do
    url "https:files.pythonhosted.orgpackages7d46aeab111f8e06793e4f0e421fcad593d547fb8313b50990f31681ee2fb1adbuild-1.2.2.post1.tar.gz"
    sha256 "b36993e92ca9375a219c99e606a122ff365a760a2d4bba0caa09bd5278b608b7"
  end

  resource "cachecontrol" do
    url "https:files.pythonhosted.orgpackages583a0cbeb04ea57d2493f3ec5a069a117ab467f85e4a10017c6d854ddcbff104cachecontrol-0.14.3.tar.gz"
    sha256 "73e7efec4b06b20d9267b441c1f733664f989fb8688391b670ca812d70795d11"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "cleo" do
    url "https:files.pythonhosted.orgpackages3c30f7960ed7041b158301c46774f87620352d50a9028d111b4211187af13783cleo-2.1.0.tar.gz"
    sha256 "0b2c880b5d13660a7ea651001fb4acb527696c01f15c9ee650f377aa543fd523"
  end

  resource "crashtest" do
    url "https:files.pythonhosted.orgpackages6e5dd79f51058e75948d6c9e7a3d679080a47be61c84d3cc8f71ee31255eb22bcrashtest-0.4.1.tar.gz"
    sha256 "80d7b1f316ebfbd429f648076d6275c877ba30ba48979de4191714a75266f0ce"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackagesd48b0f2de00c0c0d5881dc39be147ec2918725fb3628deeeb1f27d1c6cf6d9f4dulwich-0.22.8.tar.gz"
    sha256 "701547310415de300269331abe29cb5717aa1ea377af826bf513d0adfb1c209b"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackages8b504b769ce1ac4071a1ef6d86b1a3fb56cdc3a37615e8c5519e1af96cdac366fastjsonschema-2.21.1.tar.gz"
    sha256 "794d4f0a58f848961ba16af7b9c85a3e88cd360df008c59aac6fc5ae9323b5d4"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "findpython" do
    url "https:files.pythonhosted.orgpackages2d73ab2c4fb7972145c1595c07837cffc1456c1510a908f5c8bda9745930ee60findpython-0.6.3.tar.gz"
    sha256 "5863ea55556d8aadc693481a14ac4f3624952719efc1c5591abb0b4a9e965c94"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages069482699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cbhttpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
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

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackages7b6f357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0cjeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages7009d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37dkeyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages45b1ea4f68038a18c77c9467400d166d74c4ffa536f34761f7983a104357e614msgpack-1.1.1.tar.gz"
    sha256 "77b79ce34a2bdab2594f490c8e80dd62a02d650b91a75159a63ec413b8d104cd"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pbs-installer" do
    url "https:files.pythonhosted.orgpackages2f02bd162be66772b5dbdfd719d4ced63e14730d8260417db1c43ac8017e2b3epbs_installer-2025.6.12.tar.gz"
    sha256 "ae2d3990848652dca699a680b00ea8e19b970cb6172967cb00539bfeed5a7465"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages2403e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "poetry-core" do
    url "https:files.pythonhosted.orgpackages44cac2d21635a4525d427ae969d4cde155fb055c3b5d0bc4199b6de35bb6a826poetry_core-2.1.3.tar.gz"
    sha256 "0522a015477ed622c89aad56a477a57813cace0c8e7ff2a2906b7ef4a2e296a4"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagese78228175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesedf66895abc3a3d056b9698da3199b04c0e56226d530ae44a470edabf8b664f0rapidfuzz-3.13.0.tar.gz"
    sha256 "d2eaf3839e52cbcc0accbe9817a67b4b0fcf70aaeb229cfddc1c28061f9ce5d8"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagescc180bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "trove-classifiers" do
    url "https:files.pythonhosted.orgpackages38041cd43f72c241fedcf0d9a18d0783953ee301eac9e5d9db1df0f0f089d9aftrove_classifiers-2025.5.9.12.tar.gz"
    sha256 "7ca7c8a7a76e2cd314468c677c69d12cc2357711fcab4a60f87994c1589e5cb5"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages562c444f465fb2c65f40c3a104fd0c495184c4f2336d65baf398e3c75d72ea94virtualenv-20.31.2.tar.gz"
    sha256 "e10c0a9d02835e592521be48b332b6caee6887f332c111aa79a09b9e79efc2af"
  end

  resource "xattr" do
    url "https:files.pythonhosted.orgpackages62bf8b98081f9f8fd56d67b9478ff1e0f8c337cde08bcb92f0d592f0a7958983xattr-1.1.4.tar.gz"
    sha256 "b7b02ecb2270da5b7e7deaeea8f8b528c17368401c2b9d5f63e91f545b45d372"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    venv = virtualenv_install_with_resources without: "zstandard"
    resource("zstandard").stage do
      system_zstd = "--config-settings=--build-option=--system-zstd"
      system venv.root"binpython", "-m", "pip", "install", system_zstd, *std_pip_args(prefix: false), "."
    end

    generate_completions_from_executable(bin"poetry", "completions")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    # The poetry add command would fail in CI when keyring is enabled
    # https:github.comHomebrewhomebrew-corepull109777#issuecomment-1248353918
    ENV["PYTHON_KEYRING_BACKEND"] = "keyring.backends.null.Keyring"

    assert_match version.to_s, shell_output("#{bin}poetry --version")
    assert_match "Created package", shell_output("#{bin}poetry new homebrew")

    cd testpath"homebrew" do
      system bin"poetry", "config", "virtualenvs.in-project", "true"
      system bin"poetry", "add", "requests"
      system bin"poetry", "add", "boto3"
    end

    assert_path_exists testpath"homebrewpyproject.toml"
    assert_path_exists testpath"homebrewpoetry.lock"
    assert_match "requests", (testpath"homebrewpyproject.toml").read
    assert_match "boto3", (testpath"homebrewpyproject.toml").read
  end
end