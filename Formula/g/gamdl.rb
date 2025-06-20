class Gamdl < Formula
  include Language::Python::Virtualenv

  desc "Python CLI app for downloading Apple Music songs, music videos and post videos"
  homepage "https:github.comglomaticogamdl"
  url "https:files.pythonhosted.orgpackagesad4d7a075db421a05866245974161e5e11f524ebaa97b55069beece758410e30gamdl-2.4.2.tar.gz"
  sha256 "871ae15397949f3e7187a50bd03f51d5894f2457ff6eea08064233062a820b66"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "352d64fb8f8dc066d0fd3720654ffe52f8520e2254ce592dbe5a96f513c9aeec"
    sha256 cellar: :any,                 arm64_sonoma:  "0b21f64921a117e772e98214a87e9b307f9229741bab964e0e5a4050a9b5a731"
    sha256 cellar: :any,                 arm64_ventura: "86bb3b0b7ea9455ff52306daf87cae9b897631a746bf9c9f2b747e6c80b1d844"
    sha256 cellar: :any,                 sonoma:        "21aaac228864a5eef0b4d5b96e38ae3ae87d57aefa30f8e56d64c1b63db13699"
    sha256 cellar: :any,                 ventura:       "b57ad11ab65e47363264b17703f9517e14d107fa8292473ad3c9eb9ac056a4c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "099b4e30b35377719d27b75f0c33cc43a1be827eac98833ba52db5e8db178451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b8634294d2e51ab213cac6e65d060e1d274f71f67a8b18d37c5e66d0d68249"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "construct" do
    url "https:files.pythonhosted.orgpackagesb62c66bab4fef920ef8caa3e180ea601475b2cbbe196255b18f1c58215940607construct-2.8.8.tar.gz"
    sha256 "1b84b8147f6fd15bcf64b737c3e8ac5100811ad80c830cb4b2545140511c4157"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "inquirerpy" do
    url "https:files.pythonhosted.orgpackages64737570847b9da026e07053da3bbe2ac7ea6cde6bb2cbd3c7a5a950fa0ae40bInquirerPy-0.3.4.tar.gz"
    sha256 "89d2ada0111f337483cb41ae31073108b2ec1e618a49d7110b0d7ade89fc197e"
  end

  resource "m3u8" do
    url "https:files.pythonhosted.orgpackages9ba573697aaa99bb32b610adc1f11d46a0c0c370351292e9b271755084a145e6m3u8-6.0.0.tar.gz"
    sha256 "7ade990a1667d7a653bcaf9413b16c3eb5cd618982ff46aaff57fe6d9fa9c0fd"
  end

  resource "mutagen" do
    url "https:files.pythonhosted.orgpackages81e664bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pfzy" do
    url "https:files.pythonhosted.orgpackagesd95a32b50c077c86bfccc7bed4881c5a2b823518f5450a30e639db5d3711952epfzy-0.3.4.tar.gz"
    sha256 "717ea765dd10b63618e7298b2d98efd819e0b30cd5905c9707223dceeb94b3f1"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesdf0134c8d2b6354906d728703cb9d546a0e534de479e25f1b581e4094c4a85ccprotobuf-4.25.8.tar.gz"
    sha256 "6135cf8affe1fc6f76cced2641e4ea8d3e59518d1f24ae41ba97bcad82d397cd"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages8ea68452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pymp4" do
    url "https:files.pythonhosted.orgpackagesa546dfb3f5363fc71adaf419147fdcb93341029ca638634a5cc6f7e7446416b2pymp4-1.4.0.tar.gz"
    sha256 "bc9e77732a8a143d34c38aa862a54180716246938e4bf3e07585d19252b77bb5"
  end

  resource "pywidevine" do
    url "https:files.pythonhosted.orgpackages99126ff0e6ffa2711187ee629392396d7c18ae6ca8e2e576dcef2d636316d667pywidevine-1.8.0.tar.gz"
    sha256 "c14f3fe2864473416b9caa73d9a21251a02d72138e6d54d8c1a3f44b7a6b05c9"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackages947da8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "yt-dlp" do
    url "https:files.pythonhosted.orgpackagesb7fb588a23e61586960273524d3aa726bd148116d422854f727f4d59c254cb6ayt_dlp-2025.6.9.tar.gz"
    sha256 "751f53a3b61353522bf805fa30bbcbd16666126537e39706eab4f8c368f111ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gamdl --version")

    touch testpath"cookies.txt"
    assert_match "'cookies.txt' does not look like a Netscape format cookies file",
                 shell_output("#{bin}gamdl fake_url 2>&1", 1)
  end
end