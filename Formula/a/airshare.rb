class Airshare < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform content sharing in a local network"
  homepage "https://airshare.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/cb/a2/d59c18cd6a143bf860c29acb70552b7351fd7e0f56213be86b624601106b/Airshare-0.1.6.tar.gz"
  sha256 "138976933bcf2c0bc99f18901242544919e9fafe43735b4f83b19d4ae5964be7"
  license "MIT"
  revision 16

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d38659e242909f9b0c97ec3e5ccb37597b0df71068facdef398d7f3d89c2b68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b0b915618d820866bc4d1f4f159a278df6ee3eddc933d37c1b569c7138b2833"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6516cb932a1f57aca5fbd37a0cf5df33de5c76c959d23ddd809913fc1b119a54"
    sha256 cellar: :any_skip_relocation, sonoma:        "5551b05af92257ae7ddf8eb285a336dcea9cca186643afd63c12c93b9a299c61"
    sha256 cellar: :any_skip_relocation, ventura:       "ce720d0756d630ac0e926c39ae2685e13deb1dfb3eb2aaf5bbd3d90e7629e213"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c769f20c08acbeef2fe4e811fc36a7050d6d2ccacb023b6b8d5034ed8050be8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177b713cb8748755563c838899c055434d0685769481c8554b354886fd72fc4b"
  end

  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/f2/84/ea27e6ad14747d8c51afe201fb88a5c8282b6278256d30a6f71f730add88/aiohttp-3.12.12.tar.gz"
    sha256 "05875595d2483d96cb61fa9f64e75262d7ac6251a7e3c811d8e26f7d721760bd"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ba/b5/6d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473d/aiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "asyncio" do
    url "https://files.pythonhosted.org/packages/da/54/054bafaf2c0fb8473d423743e191fcdf49b2c1fd5e9af3524efbe097bafd/asyncio-3.4.3.tar.gz"
    sha256 "83360ff8bc97980e4ff25c964c7bd3923d333d177aa4f7fb736b019f26c7cb41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e8/9e/c05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4/certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/22/d1/bbc4d251187a43f69844f7fd8941426549bbe4723e8ff0a7441796b0789f/humanize-4.12.3.tar.gz"
    sha256 "8430be3a615106fdfceb0b2c1b41c4c98c6b0fc5cc59663a5539b111dd325fb0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/91/2f/a3470242707058fe856fe59241eee5635d79087100b7042a867368863a27/multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/ca/6c/3d75c196ac07ac8749600b60b03f4f6094d54e132c4d94ebac6ee0e0add0/termcolor-3.1.0.tar.gz"
    sha256 "6a6dd7fbee581909eeec6a756cff1d7f7c376063b14e4a298dc4980309e55970"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/e2/78/f681afade2a4e7a9ade696cf3d3dcd9905e28720d74c16cafb83b5dd5c0a/zeroconf-0.147.0.tar.gz"
    sha256 "f517375de6bf2041df826130da41dc7a3e8772176d3076a5da58854c7d2e8d7a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"airshare", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    port = free_port
    pid = spawn bin/"airshare", "-p", port.to_s, "homebrew-demo", "-t", "Hello Homebrew!"
    sleep 30
    output = shell_output("#{bin}/airshare -p #{port} homebrew-demo")
    assert_equal "Received: Hello Homebrew!\n", output.lines.last
    Process.kill("TERM", pid)
  end
end