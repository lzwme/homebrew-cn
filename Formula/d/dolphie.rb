class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https:github.comcharles-001dolphie"
  url "https:files.pythonhosted.orgpackages500b71afd6b459ce5cfdbf581aa45276a957b705f0908661a0d98c90c54cd1cadolphie-6.10.1.tar.gz"
  sha256 "81c1c3254efced0f0810d143389c9a9a3fbe779a9f608aae8c34d82158c7bb45"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: "some resources have to be updated manually"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "372e05e6aad3337d21ab89d35b094f3cabadcb03a5318b94cf8016f0cce7fbae"
    sha256 cellar: :any,                 arm64_sonoma:  "5f83acdae31a5c7b110fed3b7cabfc1a715a67ed2762a35feaa528bf8f87fa3c"
    sha256 cellar: :any,                 arm64_ventura: "ddbc591bb8e2c01b369c391a1df9efc93d5566eaebfdd95751b77fc0a237c8b5"
    sha256 cellar: :any,                 sonoma:        "9e7efbf9f5cf4ed9cbdf3c4c9ca3597e00145f1ace9795f2ea1597c83a40300e"
    sha256 cellar: :any,                 ventura:       "1b393474a5d78685dcd8ac1abf63c9d170f900672b42dbb22825e72ab99d1099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb160ba4b30de073326f65c0c5a67133d9be67caca25325b3e8c7c7fcb979eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f7844215d376698efa1c536c7a36c628d63e74b6206a23c10343ca2f2c7fde8"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  # `tree-sitter-*` sdists are missing C headers and therefore we have to use GitHub sources
  # Resources can be updated the following way:
  # 1. remove all resources to GitHub sources
  # 2. run `brew update-python-resources dolphie`
  # 3. replace `tree-sitter-*` resources with their versions from GitHub

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "loguru" do
    url "https:files.pythonhosted.orgpackages3a05a1dae3dffd1116099471c643b8924f5aa6524411dc6c63fdae648c4f1acaloguru-0.7.3.tar.gz"
    sha256 "19480589e77d47b8d85b2c827ad95d49bf31b0dcde16593892eb51dd18706eb6"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "myloginpath" do
    url "https:files.pythonhosted.orgpackages21309acf030d204770c1134e130e8eb1293ce5ecd6a72046aaca68fbd76ead00myloginpath-0.0.4.tar.gz"
    sha256 "c44b8d11e8f35a02eeac4b88bf244203c09cc496bfa19ce99a79561c038f9d09"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages810bfea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "plotext" do
    url "https:files.pythonhosted.orgpackagesc9d7f75f397af966fe252d0d34ffd3cae765317fce2134f925f95e7d6725d1ceplotext-5.3.2.tar.gz"
    sha256 "52d1e932e67c177bf357a3f0fe6ce14d1a96f7f7d5679d7b455b929df517068e"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pymysql" do
    url "https:files.pythonhosted.orgpackagesb38fce59b5e5ed4ce8512f879ff1fa5ab699d211ae2495f1adaa5fbba2a1eadapymysql-1.1.1.tar.gz"
    sha256 "e127611aaf2b417403c60bf4dc570124aeb4a57f5f37b8e95ae399a42f904cd0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "sqlparse" do
    url "https:files.pythonhosted.orgpackagese540edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4sqlparse-0.5.3.tar.gz"
    sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages1bcfb4a02ae702ccb3ba0e5de0aaf3197f95585f480ce9f6ed0a5936f6eb2609textual-3.4.0.tar.gz"
    sha256 "f697c3b9371bbc30c11453a094d700e95cf7c2115f68bad35f0249de67996c99"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackagesa7a2698b9d31d08ad5558f8bfbfe3a0781bd4b1f284e89bde3ad18e05101a892tree-sitter-0.24.0.tar.gz"
    sha256 "abd95af65ca2f4f7eca356343391ed669e764f37748b5352946f00f7fc78e734"
  end

  resource "tree-sitter-bash" do
    url "https:github.comtree-sittertree-sitter-basharchiverefstagsv0.25.0.tar.gz"
    sha256 "9d6bad618e712b51ff060515b0ce6872e33727148f35becb8aa3ad80044c2348"
  end

  resource "tree-sitter-css" do
    url "https:github.comtree-sittertree-sitter-cssarchiverefstagsv0.23.2.tar.gz"
    sha256 "5d442e8b04d8c743603172fb02664ae2b404f38f7a871d97cf2c89c1eedf8251"
  end

  resource "tree-sitter-go" do
    url "https:github.comtree-sittertree-sitter-goarchiverefstagsv0.23.4.tar.gz"
    sha256 "967870d7d120e9b760e538aeb8331a72f70ffcca4f1eaf1e1dea5375886d25d2"
  end

  resource "tree-sitter-html" do
    url "https:github.comtree-sittertree-sitter-htmlarchiverefstagsv0.23.2.tar.gz"
    sha256 "21fa4f2d4dcb890ef12d09f4979a0007814f67f1c7294a9b17b0108a09e45ef7"
  end

  resource "tree-sitter-java" do
    url "https:github.comtree-sittertree-sitter-javaarchiverefstagsv0.23.5.tar.gz"
    sha256 "cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0"
  end

  resource "tree-sitter-javascript" do
    url "https:github.comtree-sittertree-sitter-javascriptarchiverefstagsv0.23.1.tar.gz"
    sha256 "fc5b8f5a491a6db33ca4854b044b89363ff7615f4291977467f52c1b92a0c032"
  end

  resource "tree-sitter-json" do
    url "https:github.comtree-sittertree-sitter-jsonarchiverefstagsv0.24.8.tar.gz"
    sha256 "acf6e8362457e819ed8b613f2ad9a0e1b621a77556c296f3abea58f7880a9213"
  end

  resource "tree-sitter-markdown" do
    url "https:github.comtree-sitter-grammarstree-sitter-markdownarchiverefstagsv0.3.2.tar.gz"
    sha256 "5dac48a6d971eb545aab665d59a18180d21963afc781bbf40f9077c06cb82ae5"
  end

  resource "tree-sitter-python" do
    url "https:github.comtree-sittertree-sitter-pythonarchiverefstagsv0.23.6.tar.gz"
    sha256 "630a0f45eccd9b69a66a07bf47d1568e96a9c855a2f30e0921c8af7121e8af96"
  end

  resource "tree-sitter-regex" do
    url "https:github.comtree-sittertree-sitter-regexarchiverefstagsv0.24.3.tar.gz"
    sha256 "92f24bb779a92debe259cc1c204aab78f425f0fc1e8b4f2c03b6896d2da8f0a3"
  end

  resource "tree-sitter-rust" do
    url "https:github.comtree-sittertree-sitter-rustarchiverefstagsv0.24.0.tar.gz"
    sha256 "79c9eb05af4ebcce8c40760fc65405e0255e2d562702314b813a5dec1273b9a2"
  end

  resource "tree-sitter-toml" do
    url "https:github.comtree-sitter-grammarstree-sitter-tomlarchiverefstagsv0.7.0.tar.gz"
    sha256 "7d52a7d4884f307aabc872867c69084d94456d8afcdc63b0a73031a8b29036dc"
  end

  resource "tree-sitter-xml" do
    url "https:github.comtree-sitter-grammarstree-sitter-xmlarchiverefstagsv0.7.0.tar.gz"
    sha256 "4330a6b3685c2f66d108e1df0448eb40c468518c3a66f2c1607a924c262a3eb9"
  end

  resource "tree-sitter-yaml" do
    url "https:github.comtree-sitter-grammarstree-sitter-yamlarchiverefstagsv0.7.1.tar.gz"
    sha256 "0626a1d89d713a46acd0581b745d3dcfe0b3714279eb6cf858fe78ff850a5a2b"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Fails in Linux CI with "ParseError: end of file reached"
    # See https:github.comHomebrewhomebrew-corepull152912#issuecomment-1787257320
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}dolphie mysql:user:password@host:port 2>&1")
    assert_match "Invalid URI: Port could not be cast to integer value as 'port'", output

    assert_match version.to_s, shell_output("#{bin}dolphie --version")
  end
end