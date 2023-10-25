class SlitherAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Solidity static analysis framework written in Python 3"
  homepage "https://github.com/crytic/slither"
  url "https://files.pythonhosted.org/packages/a5/c4/d2aaf5a600a8ac176655fb7e2130a4879d766e17f51ee4694d022474ebdf/slither-analyzer-0.10.0.tar.gz"
  sha256 "d01ad88a7fc9581f717859c66d01ef1658ba49505c60e89d5cf38ce6a7f4cdff"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/slither.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee26b5cc30a0e66eaab8a109f92a3fe2e2d9357de6055674cbe7d64f33777a50"
    sha256 cellar: :any,                 arm64_ventura:  "df077dc9168d9c3b5c8463f62bf0b00c9b9be9da2700a3cb0a537daee206da73"
    sha256 cellar: :any,                 arm64_monterey: "46c2a94fb1798dbfd445ed7b94dec22f1deddd4a3e5e72f5843073acda339eb2"
    sha256 cellar: :any,                 sonoma:         "7b1cd63b50af448d83a1396c648de7a1890223e62bb2c6bea31221ea8621af73"
    sha256 cellar: :any,                 ventura:        "2653243dc1c6ced4d1f249d74c38dfea928f94c1e671916f17e873dff60d3706"
    sha256 cellar: :any,                 monterey:       "9ef88c8fae12eec2f6549c12b98f02c5d05dc1f776ca099a172f489ba9952a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e9d9a132c77171107f1a73190ab5ba6c94edf100fcb38dc0ae3a74811da358"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "crytic-compile"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "solc-select"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c4/50/a717a133bda2efc27efbf8a65398c925b6d0605213da0db6929627ccb758/aiohttp-3.9.0b0.tar.gz"
    sha256 "cecc64fd7bae6debdf43437e3c83183c40d4f4d86486946f412c113960598eee"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/99/f4/316cfb1cd62886d7bf87da48cf847ecfced48ed5f91ff8e54bc52f7fd76e/bitarray-2.8.2.tar.gz"
    sha256 "f90b2f44b5b23364d5fbade2c34652e15b1fcfe813c46f828e008f68a709160f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "cytoolz" do
    url "https://files.pythonhosted.org/packages/a0/61/c27e1e7007e3cc6989053956dfe078db84e164f22c7000b2ad1efc5b93b7/cytoolz-0.12.2.tar.gz"
    sha256 "31d4b0455d72d914645f803d917daf4f314d115c70de0578d3820deb8b101f66"
  end

  resource "eth-abi" do
    url "https://files.pythonhosted.org/packages/dc/70/02882ae2533ed4d53233481e516652c47d26c61b1ff76dee1241b5c3d049/eth_abi-4.2.1.tar.gz"
    sha256 "60d88788d53725794cdb07c0f0bb0df2a31a6e1ad19644313fe6117ac24eeeb0"
  end

  resource "eth-account" do
    url "https://files.pythonhosted.org/packages/e6/ec/41c8bd1b11997f6627f97ba7247d1d68f8089fe727cd6ae12c9fb2b966bc/eth-account-0.9.0.tar.gz"
    sha256 "5f66ecb7bc52569924dfaf4a9add501b1c2a4901eec74e3c0598cd26d0971777"
  end

  resource "eth-hash" do
    url "https://files.pythonhosted.org/packages/33/98/0a5ff6036b36018db5a728e1e1691457df191bba10a95a912d456b6d1e73/eth-hash-0.5.2.tar.gz"
    sha256 "1b5f10eca7765cc385e1430eefc5ced6e2e463bb18d1365510e2e539c1a6fe4e"
  end

  resource "eth-keyfile" do
    url "https://files.pythonhosted.org/packages/60/8e/affe6f0d1c0f02c8bbdf900cb57c5a4b97410ff341807fc3107484d2a58f/eth-keyfile-0.6.1.tar.gz"
    sha256 "471be6e5386fce7b22556b3d4bde5558dbce46d2674f00848027cb0a20abdc8c"
  end

  resource "eth-keys" do
    url "https://files.pythonhosted.org/packages/e4/24/03295c85b09f17d0d002d5cfca54614dc68e9ceaa4c8978267a1f6d75299/eth-keys-0.4.0.tar.gz"
    sha256 "7d18887483bc9b8a3fdd8e32ddcb30044b9f08fcb24a380d93b6eee3a5bb3216"
  end

  resource "eth-rlp" do
    url "https://files.pythonhosted.org/packages/f3/a2/2e6ff6eb74820a0fb5716787cb06fc9ae5035092cd830d99de83ff11197b/eth-rlp-0.3.0.tar.gz"
    sha256 "f3263b548df718855d9a8dbd754473f383c0efc82914b0b849572ce3e06e71a6"
  end

  resource "eth-typing" do
    url "https://files.pythonhosted.org/packages/f1/f7/ebefd5c416f244ae44b8626ec6ccaa7f365ce31a766b82a9f3ec69e7d5b2/eth-typing-3.5.1.tar.gz"
    sha256 "e21a8b0688581a6765f72fa184d86d06c3949e354d4af5293798abc0b4255989"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/2f/15/409cccf08bdd1b6319dd67f29c1e0545abb756e203cdf7ecb778030c9abb/eth-utils-2.3.0.tar.gz"
    sha256 "085b42f5745f46d22a186fbd873d79f66a79171c02eccd78792d1dddd672f324"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "hexbytes" do
    url "https://files.pythonhosted.org/packages/c1/94/fbfd526e8964652eec6a7b74ae18d1426e225ab602553858531ec6567d05/hexbytes-0.3.1.tar.gz"
    sha256 "a3fe35c6831ee8fafd048c4c086b986075fc14fd46258fa24ecb8d65745f9a9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "lru-dict" do
    url "https://files.pythonhosted.org/packages/83/63/21480e8ecc218b9b15672d194ea79da8a7389737c21d8406254306733cac/lru-dict-1.2.0.tar.gz"
    sha256 "13c56782f19d68ddf4d8db0170041192859616514c706b126d0df2ec72a11bd7"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "parsimonious" do
    url "https://files.pythonhosted.org/packages/ad/03/2d8d0ac1c3107945956bcef379ae11b4ecd7898147f1719911e7684afca1/parsimonious-0.9.0.tar.gz"
    sha256 "b2ad1ae63a2f65bd78f5e0a8ac510a98f3607a43f1db2a8d46636a5d9e4a30c1"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/52/5c/f2c0778278259089952f94b0884ca27a001a17ffbd992ebe30c841085f4c/protobuf-4.24.4.tar.gz"
    sha256 "5a70731910cd9104762161719c3d883c960151eea077134458503723b60e3667"
  end

  # pypandoc's convert was removed in 1.8, thus pin to use 1.7.5
  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/cd/10/7042e44e0b5020d075cd61c93dc6c26d618e5a1f4f1d2cd493fe54ab124d/pypandoc-1.7.5.tar.gz"
    sha256 "802c26aae17b64136c6d006949d8ce183a7d4d9fbd4f2d051e66f4fb9f45ca50"
  end

  resource "pyunormalize" do
    url "https://files.pythonhosted.org/packages/7f/f8/bd510f00258e135819289d0c47f136c0f8c4761c636e6817a65400b16139/pyunormalize-15.0.0.tar.gz"
    sha256 "e63fdba0d85ea04579dde2fc29a072dba773dcae600b04faf6cc90714c8b1302"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rlp" do
    url "https://files.pythonhosted.org/packages/20/63/8b5205a7f9e2792137676c2d29bd6bc9cbecca95015a55ed54d6dd02f3f6/rlp-3.0.0.tar.gz"
    sha256 "63b0465d2948cd9f01de449d7adfb92d207c1aef3982f20310f8009be4a507e8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/ee/12/d6cfa2699916e5ece53a42e486e03b5a14e672c76ddb16d4649efcf9efb8/rpds_py-0.10.6.tar.gz"
    sha256 "4ce5a708d65a8dbf3748d2474b580d606b1b9f91b5c6ab2a316e0b0cf7a4ba50"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
    sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/92/4f/56a00ce517f1a0a7da50c0e3e74cbe3ad70aa87843cb42b0119dc32fc84c/web3-6.11.1.tar.gz"
    sha256 "d301d7120922d5b9e5c9535ef9780012ea25ea4011c2b177490ba7d3ef886b92"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.12")
    crytic_compile = Formula["crytic-compile"].opt_libexec
    solc_select = Formula["solc-select"].opt_libexec
    (libexec/site_packages/"homebrew-crytic-compile.pth").write crytic_compile/site_packages
    (libexec/site_packages/"homebrew-solc-select.pth").write solc_select/site_packages
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      # slither exits with code 255 if high severity findings are found
      assert_match("5 result(s) found",
                   shell_output("#{bin}/slither --detect uninitialized-state --fail-high " \
                                "variable-0.8.0.sol-0.8.15-compact.zip 2>&1", 255))
    end
  end
end