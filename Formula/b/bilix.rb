class Bilix < Formula
  include Language::Python::Virtualenv

  desc "Lightning-fast asynchronous download tool for bilibili and more"
  homepage "https:github.comHFrost0bilix"
  url "https:files.pythonhosted.orgpackages5c120f885cee77471123a3c82da85bd1934af00aed213910987bbe5b2296997dbilix-0.18.9.tar.gz"
  sha256 "8ab1be9bcc661369cbeba95439c09716778b6b42b2505a3eaddb45175688e247"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c1bf5d778d225991d475b0a9bb0b5cd7a5d0d7fdfa716e2efead270e6e06e07"
    sha256 cellar: :any,                 arm64_sonoma:  "4ac52e2b1442a512b5d95afaed8c94e490eb81a094383cdb62decd2c45719e86"
    sha256 cellar: :any,                 arm64_ventura: "81834600e7ec4f40a0b1de992dd50b19dbe64c75c394ab6e8265d7e95bfb5187"
    sha256 cellar: :any,                 sonoma:        "bb3560ea7d81e94d31c673bf731e1554eb2c9e4b54c9511260b1c1fe762206fc"
    sha256 cellar: :any,                 ventura:       "23b45844931656b65d2cff1453f505daa9a6da1709461a1e36a08e3f5d6e8987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cec138f9906f79186214cc2571a6ef4dfd8a84b26131d8125b67405b1a3abb0"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "python@3.12"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackages0b03a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesa04466874c5256e9fbc30103b31927fd9341c8da6ccafd4721b2b3e81e6ef176anyio-4.5.0.tar.gz"
    sha256 "c5a275fe5ca0afd788001f58fca1e69e29ce706d746e317d660e21f70c530ef9"
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
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages5a2a4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebbhyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages915951b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbcjson5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
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
    url "https:files.pythonhosted.orgpackagesb1a44579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages31a4b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
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
    url "https:files.pythonhosted.orgpackages927640f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
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

  def install
    virtualenv_install_with_resources
  end

  test do
    # By pass linux CI test due to the networking issue for `bilix info`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"bilix", "info", "https:www.bilibili.comvideoav20203945"
  end
end