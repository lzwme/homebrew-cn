class Airshare < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform content sharing in a local network"
  homepage "https://airshare.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/cb/a2/d59c18cd6a143bf860c29acb70552b7351fd7e0f56213be86b624601106b/Airshare-0.1.6.tar.gz"
  sha256 "138976933bcf2c0bc99f18901242544919e9fafe43735b4f83b19d4ae5964be7"
  license "MIT"
  revision 8

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aeb30cbb777271a7d7acb9eafd84cdce8c71c04a603042647cdb7a555368b392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75ec7b28768d082aae9bea5fd5032253ac88116a13625a46e1e848abb5a62735"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55cab7b626aadac8c47177c7b5e00be7c627e19a2508346711685b10694cde79"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc170849e2c374f3ae7b2f8adb90511ab19bf68062bd54ea89660c5e04d6d560"
    sha256 cellar: :any_skip_relocation, ventura:        "3362e12dcf268f7e999b27a9df8309ef27977e6864be37147e3d3906711164df"
    sha256 cellar: :any_skip_relocation, monterey:       "5301c582c7d1a06a84f485306be2cbbdd6cf350cdcb589401d298cb24ecfccb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229963dde2b96f0de79cd97b43e744aa8d824040b04b6db89af8eb65fb40736d"
  end

  depends_on "python-click"
  depends_on "python-requests"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/18/93/1f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258b/aiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "asyncio" do
    url "https://files.pythonhosted.org/packages/da/54/054bafaf2c0fb8473d423743e191fcdf49b2c1fd5e9af3524efbe097bafd/asyncio-3.4.3.tar.gz"
    sha256 "83360ff8bc97980e4ff25c964c7bd3923d333d177aa4f7fb736b019f26c7cb41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/76/21/7a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75c/humanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/b4/b0/a4f6ceb219d3cfed5f1f8dcdbf026f9224b1da0d4da9e57af01d814fec17/zeroconf-0.131.0.tar.gz"
    sha256 "90c431e99192a044a5e0217afd7ca0ca9824af93190332e6f7baf4da5375f331"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    port = free_port
    _, _, wait_thr = Open3.popen2 bin/"airshare", "-p", port.to_s, "homebrew-demo", "-t", "Hello Homebrew!"
    sleep 10
    output = shell_output("#{bin}/airshare -p #{port} homebrew-demo")
    assert_equal "Received: Hello Homebrew!\n", output.lines.last
    Process.kill("TERM", wait_thr.pid)
  end
end