class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https:docs.keeper.ioenprivileged-access-managercommander-clioverview"
  url "https:files.pythonhosted.orgpackages625b5f0976956f5093486391438be158178f15c8dd574d45a0cf2d0565e09572keepercommander-17.0.19.tar.gz"
  sha256 "eb4c6da19ba3b3f3b399c23dc0910e5634847883fe73a9465ea156369a8da122"
  license "MIT"
  head "https:github.comKeeper-SecurityCommander.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3135211e875e6b956fb0f75e45ca24069b721e9f6d192ce4a33a93e57e155c3"
    sha256 cellar: :any,                 arm64_sonoma:  "324b74c1ceca937f2dc43c63e4996b33f69933b5f6a7d07ff5f9d2896de9f466"
    sha256 cellar: :any,                 arm64_ventura: "6914589becdff584ca8441f7e327a0a8f5e53bfa1d52a4aa1adf54668f297326"
    sha256 cellar: :any,                 sonoma:        "69be274bdb770ded831f2e5b2a914c032b4feadeea1e611b9e619e660df2333a"
    sha256 cellar: :any,                 ventura:       "203fbcbdc984395ae7cb3dbc7a5a5bcd140dc8655b028174e39b93568ace8882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eaf1ab21ad9c94506af083e186e0ff73d571953cbda79a2023135d19f332d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0fd7f54265464573830fdc12b4961c0395cc3149617e8f0ba4a6a0acc5f910"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # bcrypt dependencies

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "ffmpeg"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "python@3.13"
  depends_on "srtp"

  on_macos do
    depends_on "openssl@3"
  end

  resource "aioice" do
    url "https:files.pythonhosted.orgpackages95a245dfab1d5a7f96c48595a5770379acf406cdf02a2cd1ac1729b599322b08aioice-0.10.1.tar.gz"
    sha256 "5c8e1422103448d171925c678fb39795e5fe13d79108bebb00aa75a899c2094a"
  end

  resource "aiortc" do
    url "https:files.pythonhosted.orgpackages0da8cebfc59aaa13fd48466db152f9fbb81c476bda387ecddfc340cd62411aecaiortc-1.12.0.tar.gz"
    sha256 "c99d89a60a473074532020329de7ee23253bac17606d85ba4aab4c6148e94b39"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "asciitree" do
    url "https:files.pythonhosted.orgpackages2d6a885bc91484e1aa8f618f6f0228d76d0e67000b0fdd6090673b777e311913asciitree-0.3.3.tar.gz"
    sha256 "4aa4b9b649f85e3fcb343363d97564aa1fb62e249677f2e18a96765145cc0f6e"
  end

  resource "av" do
    url "https:files.pythonhosted.orgpackages86f60b473dab52dfdea05f28f3578b1c56b6c796ce85e76951bab7c4e38d5a74av-14.4.0.tar.gz"
    sha256 "3ecbf803a7fdf67229c0edada0830d6bfaea4d10bfb24f0c3f4e607cd1064b42"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagesbb5d6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77bbcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackagesebcc4529123364d41f342145f2fd775307eaed817cd22810895dea10e15a4d06fido2-1.2.0.tar.gz"
    sha256 "e39f95920122d64283fda5e5581d95a206e704fa42846bfa4662f86aa0d3333b"
  end

  resource "google-crc32c" do
    url "https:files.pythonhosted.orgpackages19ae87802e6d9f9d69adfaedfcfd599266bf386a54d0be058b532d04c794f76dgoogle_crc32c-1.7.1.tar.gz"
    sha256 "2bff2305f98846f3e825dbeec9ee406f89da7962accdb29356e4eadc251bd472"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https:files.pythonhosted.orgpackagese8acfb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages7666650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "keeper-secrets-manager-core" do
    url "https:files.pythonhosted.orgpackagesc4b21e0fe5d7b64ddb98609a16e35ded1234bd2bb48a67bc302facb27adbdda1keeper_secrets_manager_core-16.6.6.tar.gz"
    sha256 "bda9e733908b34edbac956825fc062e6934894f210d49b0bba1679d167d7be80"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages1348718c1e104a2e89970a8ff3b06d87e152834b576c570a6908f8c17ba88d65protobuf-6.31.0.tar.gz"
    sha256 "314fab1a6a316469dc2dd46f993cbbe95c861ea6807da910becfe7475bc26ffe"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackagesbad5861a7daada160fcf6b0393fb741eeb0d0910b039ad7f0cd56c39afdd4a20pycryptodomex-3.22.0.tar.gz"
    sha256 "a1da61bacc22f93a91cbe690e3eb2022a03ab4123690ab16c46abb693a9df63d"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages77ab5250d56ad03884ab5efd07f734203943c8a8ab40d551e208af81d0257bf2pydantic-2.11.4.tar.gz"
    sha256 "32738d19d63a226a52eed76645a98ee07c1f410ee41d93b4afbfa85ed8111c2d"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pyee" do
    url "https:files.pythonhosted.orgpackages95031fd98d5841cd7964a27d729ccf2199602fe05eb7a405c1462eb7277945edpyee-13.0.0.tar.gz"
    sha256 "b391e3c5a434d1f5118a25615001dbc8f669cf410ab67d04c4d4e07c55481c37"
  end

  resource "pylibsrtp" do
    url "https:files.pythonhosted.orgpackages54c8a59e61f5dd655f5f21033bd643dd31fe980a537ed6f373cdfb49d3a3bd32pylibsrtp-0.12.0.tar.gz"
    sha256 "f5c3c0fb6954e7bb74dc7e6398352740ca67327e6759a199fe852dbc7b84b8ac"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages9f26e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackages882c7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5bafpython_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackages825ce6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages21e626d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3f50bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56fzipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "keepersecurity.com", shell_output("#{bin}keeper server")
  end
end