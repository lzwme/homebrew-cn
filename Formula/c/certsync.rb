class Certsync < Formula
  include Language::Python::Virtualenv

  desc "Dump NTDS with golden certificates and UnPAC the hash"
  homepage "https://github.com/zblurx/certsync"
  url "https://files.pythonhosted.org/packages/c8/75/3928920bdbfb0af317446236fad17b47a1d6aad507f1ae2eed6bbf7e7ad9/certsync-0.1.6.tar.gz"
  sha256 "bbfffd10f36edcb8c4d2d5033f2a2e1e7d641e41d6c5bd11069e7b0827fa1c8d"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea181adaec6ed0a94ced8da8c8dd19e58c195ec392f21c8b0d15499e2b96654b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecd350cab49a1c242763301b33ad5be428aae6ef21df8f044a28e2797c647510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da166174ec8f537b97debc55fd3b645b85ed8589314927e3a8a4e0c243bb4198"
    sha256 cellar: :any_skip_relocation, sonoma:        "571541a137967bacca544a2a415dfac33b9cff68f96df8dde0f3dff14104471a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37ecab9438e360d17d0b237bc9752bcf932ce28f39f2f43c6e7cd0f82a3be079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e573e2a4f63c5d9f8957158710958bf5faf62c62b4157ba85c2a21572b6f12d0"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: ["certifi", "cryptography"],
                extra_packages:   "pycryptodomex"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "certipy-ad" do
    url "https://files.pythonhosted.org/packages/ff/fd/349505ced12b137fc05c174fde5b798fcefa032dfbd8bf70549a65598e42/certipy-ad-4.8.2.tar.gz"
    sha256 "03aa7e898eff2946c32494f82c2f156afbbc966fd157e599780ab19d638eaf50"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "dsinternals" do
    url "https://files.pythonhosted.org/packages/f0/29/41a6937ecc61812d09b9177a09c6f4a3edc499c0e227180d572a23e24e7b/dsinternals-1.2.5-py3-none-any.whl"
    sha256 "25c544558381a86644fc6ef3b131f2a7450675b35e324553cb414b696d86d7bd"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "impacket" do
    url "https://files.pythonhosted.org/packages/67/7f/1058cc156b6a6812b4218383c204b854f36211de18601f78b8d9a1226389/impacket-0.13.0.tar.gz"
    sha256 "d09a52befc54db82033360567deb70c48a081813d08a2221b2d1a259cd7e4e3a"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/43/ac/96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0/ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "ldapdomaindump" do
    url "https://files.pythonhosted.org/packages/14/48/2757e0453f828e33f7b41e5489976fbe7d504d513e07da53eb904030a288/ldapdomaindump-0.10.0.tar.gz"
    sha256 "cbc66b32a7787473ffd169c5319acde46c02fdc9d444556e6448e0def91d3299"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "pyspnego" do
    url "https://files.pythonhosted.org/packages/f9/e4/8b32a91aeba6fbc6943a630c44b2fe038615e5c7dec8814316fafdcf4bf4/pyspnego-0.12.0.tar.gz"
    sha256 "e1d9cd3520a87a1d6db8d68783b17edc4e1464eae3d51ead411a51c82dbaae67"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-ntlm" do
    url "https://files.pythonhosted.org/packages/15/74/5d4e1815107e9d78c44c3ad04740b00efd1189e5a9ec11e5275b60864e54/requests_ntlm-1.3.0.tar.gz"
    sha256 "b29cc2462623dffdf9b88c43e180ccb735b4007228a542220e882c58ae56c668"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "unicrypto" do
    url "https://files.pythonhosted.org/packages/26/80/3bdb8a8677a190be548c86e9247c5949ca0c9bc96e1b42c9ac9accf6681e/unicrypto-0.0.12.tar.gz"
    sha256 "7b7fc4f54d56422abbbc41f863f99b27a8674531f4a42003f3f953e4a722bde1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/61/f1/ee81806690a87dab5f5653c1f146c92bc066d7f4cebc603ef88eb9e13957/werkzeug-3.1.6.tar.gz"
    sha256 "210c6bede5a420a913956b4791a7f4d6843a43b6fcee4dfa08a65e93007d0d25"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/certsync -randomize -dc-ip localhost 2>&1")
    assert_match "Got error: nameserver localhost is not a dns.nameserver.Nameserver", output

    assert_match "Dump NTDS with golden certificates", shell_output("#{bin}/certsync -h")
  end
end