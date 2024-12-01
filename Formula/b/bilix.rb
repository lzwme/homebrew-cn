class Bilix < Formula
  include Language::Python::Virtualenv

  desc "Lightning-fast asynchronous download tool for bilibili and more"
  homepage "https:github.comHFrost0bilix"
  url "https:files.pythonhosted.orgpackages5c120f885cee77471123a3c82da85bd1934af00aed213910987bbe5b2296997dbilix-0.18.9.tar.gz"
  sha256 "8ab1be9bcc661369cbeba95439c09716778b6b42b2505a3eaddb45175688e247"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c1e5cde851eb27c85abb5c41bed3edfd4d45f68adf9661621e6c3a00ceb2061"
    sha256 cellar: :any,                 arm64_sonoma:  "49a684a00f27ec7f6ce57a768886cf1ee731d6fc75403e7341248ec02e640511"
    sha256 cellar: :any,                 arm64_ventura: "10290bffb1be855b97822cac52915f16180185794478e53ee99bdb960b7d4c4c"
    sha256 cellar: :any,                 sonoma:        "78d4865ffa1dc7106db2272b789a90a46f509bfc7b0186c18c3b916280eb4b40"
    sha256 cellar: :any,                 ventura:       "669ef0d47cfbd0f9c8ac6b9a70c5af94ff828cd271867ad981a0ff6ebf39b2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216ac59112c834424f935f42cedcec79ea202f40a817bb0dff133315b7b0760c"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.13"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackages0b03a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages9f0945b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546ccanyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "browser-cookie3" do
    url "https:files.pythonhosted.orgpackages277438bce788694ab4db1f91b729d782e85fefe855ccd1a5f74ee03e6ac43008browser-cookie3-0.19.1.tar.gz"
    sha256 "3031ad14b96b47ef1e4c8545f2f463e10ad844ef834dcd0ebdae361e31c6119a"
  end

  resource "bs4" do
    url "https:files.pythonhosted.orgpackagesc9aa4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
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
    url "https:files.pythonhosted.orgpackages6a41d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages10df676b7cf674dd1bdc71a64ad393c89879f75e4a0ab8395165b498262ae106httpx-0.28.0.tar.gz"
    sha256 "0858d3bab51ba7e386637f22a61d8ccddaeec5f3fe4209da3a6168dbb91573e0"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages5a2a4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebbhyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages853dbbe62f3d0c05a689c711cff57b2e3ac3d3e526380adb7c781989f075115cjson5-0.10.0.tar.gz"
    sha256 "e66941c8f0a02026943c52c2eb34ebeb2a6f819a0be05920a6f5243cd30fd559"
  end

  resource "lz4" do
    url "https:files.pythonhosted.orgpackagesa431ec1259ca8ad11568abaf090a7da719616ca96b60d097ccc5799cd0ff599clz4-4.3.3.tar.gz"
    sha256 "01fe674ef2889dbb9899d8a67361e0c4a2c833af5aeb37dd505727cf5d2a131e"
  end

  resource "m3u8" do
    url "https:files.pythonhosted.orgpackages9ba573697aaa99bb32b610adc1f11d46a0c0c370351292e9b271755084a145e6m3u8-6.0.0.tar.gz"
    sha256 "7ade990a1667d7a653bcaf9413b16c3eb5cd618982ff46aaff57fe6d9fa9c0fd"
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
    url "https:files.pythonhosted.orgpackages6abb8e59a30b83102a37d24f907f417febb58e5f544d4f124dd1edcd12e078bfprotobuf-5.29.0.tar.gz"
    sha256 "445a0c02483869ed8513a585d80020d012c6dc60075f96fa0563a724987b1001"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages135213b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages11dce66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828fpycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages4186a03390cb12cf64e2a8df07c267f3eb8d5035e0f9a04bb20fb79403d2a00epydantic-2.10.2.tar.gz"
    sha256 "2bc2d7f17232e0841cbba4641e65ba1eb6fafb3a08de3a091ff3ce14a197c4fa"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesa69f7de1f19b6aea45aeb441838782d68352e71bfa98ee6fa048d5041991b33epydantic_core-2.27.1.tar.gz"
    sha256 "62a763352879b84aa31058fc931884055fd75089cccbd9d58bb6afd01141b235"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pymp4" do
    url "https:files.pythonhosted.orgpackagesa546dfb3f5363fc71adaf419147fdcb93341029ca638634a5cc6f7e7446416b2pymp4-1.4.0.tar.gz"
    sha256 "bc9e77732a8a143d34c38aa862a54180716246938e4bf3e07585d19252b77bb5"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  # update bilibili play_info api, upstream pr ref, https:github.comHFrost0bilixpull244
  patch do
    url "https:github.comHFrost0bilixcommit72c259d88b2fffb6cd530fce01b8c3d35fb79335.patch?full_index=1"
    sha256 "6f241455c6f1940626ed660d97abbcf3eecd3931cca3b6db6acd1f961649b6cb"
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