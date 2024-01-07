class Bilix < Formula
  include Language::Python::Virtualenv

  desc "Lightning-fast asynchronous download tool for bilibili and more"
  homepage "https:github.comHFrost0bilix"
  url "https:files.pythonhosted.orgpackagesdeb5ee8a2f701d4b4499111772ea368164d3a73a2ccdbb8e688b293d9dd12decbilix-0.18.5.tar.gz"
  sha256 "b5921c141c79ba58f3cd1119a81ac7cce17a0b852f266759de1004707a02a8ba"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f19cd78257e15afe1dbe97f411378222ddfb1b52d2d4cc8878d539c7554ffcf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e550f1ff8243cf203a19c6a983ee01eb2ab6262a83345efc7e51f06bec1ace92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04d685381f125b8a0710ae625a4a0eac5c77649dc13f1e6d8548506b86143b83"
    sha256 cellar: :any_skip_relocation, sonoma:         "b76755947ae12833297e85609cb7f6effacfd7461132705d37e6347cf19078f4"
    sha256 cellar: :any_skip_relocation, ventura:        "888dd55b8fcda7aa4892db34d4439ea7998468826767e37966c6c87ed9a17ebe"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae83107891645d92ec9fc3549d6ec37afad0c1e203893129f60410a4fe5fbd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "743ad18779e54d728d7f15de3ce6135c0bbcf1a9e4eb785a29bdaae21fad8f68"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackagesaf41cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages2db87333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "browser-cookie3" do
    url "https:files.pythonhosted.orgpackages277438bce788694ab4db1f91b729d782e85fefe855ccd1a5f74ee03e6ac43008browser-cookie3-0.19.1.tar.gz"
    sha256 "3031ad14b96b47ef1e4c8545f2f463e10ad844ef834dcd0ebdae361e31c6119a"
  end

  resource "bs4" do
    url "https:files.pythonhosted.orgpackages10ed7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "construct" do
    url "https:files.pythonhosted.orgpackagesb62c66bab4fef920ef8caa3e180ea601475b2cbbe196255b18f1c58215940607construct-2.8.8.tar.gz"
    sha256 "1b84b8147f6fd15bcf64b737c3e8ac5100811ad80c830cb4b2545140511c4157"
  end

  resource "danmakuc" do
    url "https:files.pythonhosted.orgpackagesf581171b7d5706546d7bd9dd431589e384f65d3007bb7bcb1475e3c677d7e243danmakuC-0.3.6.tar.gz"
    sha256 "db6b7dcf3dba1595c08a37a6f27f925fb40b9b8c110ff013872ac575c9c30132"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https:files.pythonhosted.orgpackages2a32fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https:files.pythonhosted.orgpackages3e9bfda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages185678a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesbd262dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages5a2a4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebbhyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackagesf94089e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097bjson5-0.9.14.tar.gz"
    sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
  end

  resource "lz4" do
    url "https:files.pythonhosted.orgpackagesa431ec1259ca8ad11568abaf090a7da719616ca96b60d097ccc5799cd0ff599clz4-4.3.3.tar.gz"
    sha256 "01fe674ef2889dbb9899d8a67361e0c4a2c833af5aeb37dd505727cf5d2a131e"
  end

  resource "m3u8" do
    url "https:files.pythonhosted.orgpackagesd4f310e8d8879f284c17ea658a9ddca3b4f9958697d8fd3e50d149133f2a3dc7m3u8-4.0.0.tar.gz"
    sha256 "32cb3300c702e802944427ecefbe5006e09f7fb5578334ce33f01e2e4bf05470"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages595fb2d00e6a08d97656a27832d4d146e03ffc46ae74b4699740674bea13a905protobuf-4.25.1.tar.gz"
    sha256 "57d65074b4f5baa4ab5da1605c02be90ac20c8b40fb137d6a8df9f416b0d0ce2"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb13842a8855ff1bf568c61ca6557e2203f318fb7afeadaf2eb8ecfdbde107151pycryptodome-3.19.1.tar.gz"
    sha256 "8ae0dd1bcfada451c35f9e29a3e5db385caabc190f98e4a80ad02a61098fb776"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages3f1384f2aea851d75e12e7f32ccc11a00f1defc3d285b4ed710e5d049f31c5a6pycryptodomex-3.19.1.tar.gz"
    sha256 "0b7154aff2272962355f8941fd514104a88cb29db2d8f43a29af900d6398eb1c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages51cd721eb771f3f09f60de0807e240c3acf44c38828d0ced869fe8df7e79801bpydantic-1.10.13.tar.gz"
    sha256 "32c8b48dcd3b2ac4e78b0ba4af3a2c2eb6048cb75202f0ea7b34feb740efc340"
  end

  resource "pymp4" do
    url "https:files.pythonhosted.orgpackagesa546dfb3f5363fc71adaf419147fdcb93341029ca638634a5cc6f7e7446416b2pymp4-1.4.0.tar.gz"
    sha256 "bc9e77732a8a143d34c38aa862a54180716246938e4bf3e07585d19252b77bb5"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # By pass linux CI test due to the networking issue for `bilix info`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"bilix", "info", "https:www.bilibili.comvideoav20203945"
  end
end