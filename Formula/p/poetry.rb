class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https://python-poetry.org/"
  url "https://files.pythonhosted.org/packages/86/6a/ffbc481326a34c0585da868e85d51a0b0ddca8adc80f43803860e87b2d43/poetry-2.4.2.tar.gz"
  sha256 "e547fa69196fc109ee0900e233222732b08b8732c4345252a34d68968c0498f2"
  license "MIT"
  head "https://github.com/python-poetry/poetry.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "98b687f83939f0264b6eec915d890721295ca260649b7d99581f711c20d8dba8"
    sha256 cellar: :any, arm64_sequoia: "6384606d69ff0e971b10fb06afe3e3109b9c3ee441b8a3905c2dba1869237e72"
    sha256 cellar: :any, arm64_sonoma:  "a8678ebcb0b9518d7748c98e98f3d4a6eb63502d9496fe96bc2d568d7c159f03"
    sha256 cellar: :any, arm64_linux:   "5ebf360c6e4c023dcbe6842e926cc5ed78d0515083b86574364054b4786997a2"
    sha256 cellar: :any, x86_64_linux:  "231bb56e96ca9c2351c47e724e06424d17baf46c2700594d65b55cd732d9f88e"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "ninja" => :build # for rapidfuzz
  depends_on "rust" => :build # for cachecontrol
  depends_on "certifi" => :no_linkage
  depends_on "cffi"
  depends_on "python@3.14"
  depends_on "zstd"

  uses_from_macos "libffi"

  on_linux do
    depends_on "cryptography" => :no_linkage
  end

  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   %w[jeepney secretstorage xattr]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "build" do
    url "https://files.pythonhosted.org/packages/4d/b7/1db48a9ce2984842c8c886432ec8a2719613322e868a966ba82a28862f25/build-1.6.0.tar.gz"
    sha256 "bd2c8afc603e7a2e0ce70e2ea85f0a6d02043bafbd307f5bada0f98669eca5af"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/2d/f6/c972b32d80760fb79d6b9eeb0b3010a46b89c0b23cf6329417ff7886cd22/cachecontrol-0.14.4.tar.gz"
    sha256 "e6220afafa4c22a47dd0badb319f84475d79108100d04e26e8542ef7d3ab05a1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "cleo" do
    url "https://files.pythonhosted.org/packages/3c/30/f7960ed7041b158301c46774f87620352d50a9028d111b4211187af13783/cleo-2.1.0.tar.gz"
    sha256 "0b2c880b5d13660a7ea651001fb4acb527696c01f15c9ee650f377aa543fd523"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/6e/5d/d79f51058e75948d6c9e7a3d679080a47be61c84d3cc8f71ee31255eb22b/crashtest-0.4.1.tar.gz"
    sha256 "80d7b1f316ebfbd429f648076d6275c877ba30ba48979de4191714a75266f0ce"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/0d/7b/d03c166f6098314824bdd2e661a32563c0ebe8c5e3344ed212d2ffc96a10/dulwich-1.2.14.tar.gz"
    sha256 "ed8bfcfe1c7e187d1bc5e78f7c128a07d229d7b425433b04cbb89334678bd3b1"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/33/a4/9473c7c3b87009d9c1d74034e4a0f6a35ff0d42dd0f9866d0c3ec4e9217b/fastjsonschema-2.22.2.tar.gz"
    sha256 "72064e12356a7d6ef02165be2946b9abadbdf238536e07eb587e3dbaa33099cf"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/6d/30/03b03951873a1a0ffc7e8ca0e10c15597b59e8d0e39260704cd2ea087bc4/filelock-3.32.4.tar.gz"
    sha256 "2bde2e4cf732e0153406d8a7bc80620ecf5e621fe0d25e41143c4e3b4733ff30"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/78/e5/dd65baa266c24fa2ff9aaed20e17ec6530c063939fd11741964085a02d76/findpython-0.8.0.tar.gz"
    sha256 "53b32264874dfa5990bd09d717819386d8db3149d89fe20f88fe1078de286bae"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/06/fe/b9f481cf0cc867958a21338baa900357b7b7d86cac9b025948049d77923c/installer-1.0.1.tar.gz"
    sha256 "052c7fc3721d54c696e2dea019be67539d7b144e924f559f54beb3121831c364"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/6d/44/ea2100ec54d30c46ee9dba10a3bfb79b655e96c6df237238a3234c75869b/msgpack-1.2.2.tar.gz"
    sha256 "9eb0b0e602064527a045ea28c4f174ed69383587e29cebe28947e3b84106eb2a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pbs-installer" do
    url "https://files.pythonhosted.org/packages/4f/96/a5a9394671b1c9c600d3bfa19f36d199f92073ecd61677a74ef9d6f96222/pbs_installer-2026.8.25.tar.gz"
    sha256 "55716bb41a8f86afee5812485ae71e96dcd3499aad6cb7fa75d7825993e15728"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/24/03/e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87/pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/06/cf1564dcc2e2261c8c8c6c05628dc8b418943bdae2a4e58640ceb2f770fa/platformdirs-4.11.5.tar.gz"
    sha256 "e8b31f4f8bcbbedef91a6b57a706255e4f148d2a4e01648382a0a47342539173"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/b0/97/f7bb55470bb7890d9b3d3f9fa761083d5c9a6838b17c94a41bf2939f89ef/poetry_core-2.4.0.tar.gz"
    sha256 "4e8c7496cf797998ffc493f2e23eba4b038c894c08eadacdcdf688945de6b43a"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/91/96/0f93e27c9f60a650838f2118159aa115fd5732c0716247917b7ba7ede665/python_discovery-1.6.0.tar.gz"
    sha256 "6393b4eae1be8b2182670635e7baff89ac21cb9f8e86fd1ff40c7b1144febb4c"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/2c/21/ef6157213316e85790041254259907eb722e00b03480256c0545d98acd33/rapidfuzz-3.14.5.tar.gz"
    sha256 "ba10ac57884ce82112f7ed910b67e7fb6072d8ef2c06e30dc63c0f604a112e0e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/c2/e3/7ca82ee24c82d344584abd5b8637b3bd056f2900226e8d82fc22f1184b92/trove_classifiers-2026.6.1.19.tar.gz"
    sha256 "c5132b4b61a829d11cfbd2d72e97f20a45ed6edb95e45c5efdeb5e00836b2745"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/79/41/c3f34799487924f2a6f43b8a8b7acd345a6c61aac2211d4bced8621ca4f1/virtualenv-21.7.7.tar.gz"
    sha256 "6874376f99ba6b8d4e3ee8bde67f9285412400c7d5b29ba41ee6daa5e0221bdc"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/08/d5/25f7b19af3a2cb4000cac4f9e5525a40bec79f4f5d0ac9b517c0544586a0/xattr-1.3.0.tar.gz"
    sha256 "30439fabd7de0787b27e9a6e1d569c5959854cb322f64ce7380fedbfa5035036"
  end

  def install
    without = OS.mac? ? ["jeepney", "secretstorage"] : ["xattr"]
    virtualenv_install_with_resources(without:)
    generate_completions_from_executable(bin/"poetry", "completions")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    # The poetry add command would fail in CI when keyring is enabled
    # https://github.com/Homebrew/homebrew-core/pull/109777#issuecomment-1248353918
    ENV["PYTHON_KEYRING_BACKEND"] = "keyring.backends.null.Keyring"

    assert_match version.to_s, shell_output("#{bin}/poetry --version")
    assert_match "Created package", shell_output("#{bin}/poetry new homebrew")

    cd testpath/"homebrew" do
      system bin/"poetry", "config", "virtualenvs.in-project", "true"
      system bin/"poetry", "add", "requests"
      system bin/"poetry", "add", "boto3"
    end

    assert_path_exists testpath/"homebrew/pyproject.toml"
    assert_path_exists testpath/"homebrew/poetry.lock"
    assert_match "requests", (testpath/"homebrew/pyproject.toml").read
    assert_match "boto3", (testpath/"homebrew/pyproject.toml").read
  end
end