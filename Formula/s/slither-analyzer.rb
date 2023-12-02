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
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "043a80246461c4af781a582f27945ee5c52a99f2f3f5d38b10154ff6c2f79d0f"
    sha256 cellar: :any,                 arm64_ventura:  "eb5865a3fc426d52ec63be2d52b6b85b2ecd115f449822f8ddcab8a33725240a"
    sha256 cellar: :any,                 arm64_monterey: "a6d0ed4a3a7d490ccf83f727869d9900b4a6ea3ec62a35e0e6f44e3adee9221d"
    sha256 cellar: :any,                 sonoma:         "50b6940117f575dc055647d2ea67e006265d575207a897c520b5f25e2c291529"
    sha256 cellar: :any,                 ventura:        "a4aded5e60bb4b99f75aa4ccdd7bada2c09e580fedcd80594af8824f4a3451ec"
    sha256 cellar: :any,                 monterey:       "21b32dcec5ea20865f718d0e5d60e2051cd8a6c65dae17c6e5e8e4b6a9beaaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7986abd72f2837b838c40d720da1e8dd6b0f7caf61018c4c872f412a11ad9b1a"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "crytic-compile"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-toml"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "solc-select"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/54/07/9467d3f8dae29b14f423b414d9e67512a76743c5bb7686fb05fe10c9cc3e/aiohttp-3.9.1.tar.gz"
    sha256 "8fc49a87ac269d4529da45871e2ffb6874e87779c3d0e2ccd813c0899221239d"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/47/10/49d7e3b7cbe95ff602f47a5821c1c4bec27b146e5621dc516ca519070ac0/bitarray-2.8.3.tar.gz"
    sha256 "e15587b2bdf18d32eb3ba25f5f5a51bedd0dc06b3112a4c53dab5e7753bc6588"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d6/37/a0a75c2cae532ecb155d05edc1fbbe54fa3957e86f875a38542f87e1379c/cbor2-5.5.1.tar.gz"
    sha256 "f9e192f461a9f8f6082df28c035b006d153904213dc8640bed8a72d72bbc9475"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/46/99/de5a08d64ca9e5c31a7d0ee88c39283aa34a53c7fd08a8d83e8051523ab3/eth-account-0.10.0.tar.gz"
    sha256 "474a2fccf7286230cf66502565f03b536921d7e1fdfceba198e42160e5ac4bc1"
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
    url "https://files.pythonhosted.org/packages/c8/52/f5d10803345dd06f9301b4871e8ebb39971a4238b60c61f84ffc83379611/eth-typing-3.5.2.tar.gz"
    sha256 "22bf051ddfaa35ff827c30090de167e5c5b8cc6d343f7f35c9b1c7553f6ab64d"
  end

  resource "eth-utils" do
    url "https://files.pythonhosted.org/packages/7c/17/8a43def3267f25df94fc0d3ef66a76b00aee7bab35b1d2ff41400eedec1a/eth-utils-2.3.1.tar.gz"
    sha256 "56a969b0536d4969dcb27e580521de35abf2dbed8b1bf072b5c80770c4324e27"
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
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/a8/74/77bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03aff/jsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/d4/84/8f5072792a260016048d3a5ae5186ec3be9e090480ddf5446484394dd8c3/jsonschema_specifications-2023.11.1.tar.gz"
    sha256 "c9b234904ffe02f079bf91b14d79987faa685fd4b39c377a0996954c0090b9ca"
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
    url "https://files.pythonhosted.org/packages/59/5f/b2d00e6a08d97656a27832d4d146e03ffc46ae74b4699740674bea13a905/protobuf-4.25.1.tar.gz"
    sha256 "57d65074b4f5baa4ab5da1605c02be90ac20c8b40fb137d6a8df9f416b0d0ce2"
  end

  # pypandoc's convert was removed in 1.8, thus pin to use 1.7.5
  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/cd/10/7042e44e0b5020d075cd61c93dc6c26d618e5a1f4f1d2cd493fe54ab124d/pypandoc-1.7.5.tar.gz"
    sha256 "802c26aae17b64136c6d006949d8ce183a7d4d9fbd4f2d051e66f4fb9f45ca50"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/1a/72/acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025b/pycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "pyunormalize" do
    url "https://files.pythonhosted.org/packages/dc/5b/ddc89263363422c0d52fdc0a4d88a126621d5cb60359cd45679d3c0447fc/pyunormalize-15.1.0.tar.gz"
    sha256 "cf4a87451a0f1cb76911aa97f432f4579e1f564a2f0c84ce488c73a73901b6c1"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/80/ce/e99def6196f53af8de12a9c36968de32f80b7871084d677d0dfcd2762d0b/referencing-0.31.1.tar.gz"
    sha256 "81a1471c68c9d5e3831c30ad1dd9815c45b558e596653db751a2bfdd17b3b9ec"
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
    url "https://files.pythonhosted.org/packages/48/0b/f42f99419c5150c2741fe28bf97674d928d46ee17f46f2bc5be031cce0bc/rpds_py-0.13.2.tar.gz"
    sha256 "f8eae66a1304de7368932b42d801c67969fd090ddb1a7a24f27b435ed4bed68f"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  resource "web3" do
    url "https://files.pythonhosted.org/packages/40/2a/0070855171b7f68d51952b90a4b35eb78c8a5f90db644cb372b60d7fae4d/web3-6.11.4.tar.gz"
    sha256 "5bf785e63868c271ebee05a9ab257858630a0b105d34872cfe6a6049a887fec6"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/ca/f7/2af788563995eeec32b920c0640a6bc54777c89c780030a7754f95166b7f/yarl-1.9.3.tar.gz"
    sha256 "4a14907b597ec55740f63e52d7fee0e9ee09d5b9d57a4f399a7423268e457b57"
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