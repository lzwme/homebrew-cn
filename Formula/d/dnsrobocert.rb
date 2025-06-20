class Dnsrobocert < Formula
  include Language::Python::Virtualenv

  desc "Manage Let's Encrypt SSL certificates based on DNS challenges"
  homepage "https:dnsrobocert.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages5f19e8d64f9edb462c060c3fc95cae1410d7263fe8d66f80ff4a0253d7201758dnsrobocert-3.26.1.tar.gz"
  sha256 "b4f49ce4ff6db7e845e46597e99d9d464d1ddb15bea3e9dee729643a0092a911"
  license "MIT"
  revision 2
  head "https:github.comadferranddnsrobocert.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ee2c69b5dcd77e93b3011f6c7662b96e5f0c927898b94c10f9b10916e062fa1"
    sha256 cellar: :any,                 arm64_sonoma:  "1a78c73983035f12c00aade2c10fab5de47fc19c2a9fce712e3847e1ae14a312"
    sha256 cellar: :any,                 arm64_ventura: "f2d41072bea855bca8ed095fc48975981c77f20a387b2d6a7406693b0c54c21a"
    sha256 cellar: :any,                 sonoma:        "600a9ebcb49e69d430bcf97b99d0c309bedb142b08d7f32372858cf19f5f03cb"
    sha256 cellar: :any,                 ventura:       "b86e44b4c0a464f313c246fb88acf88dfedceec095f175faae85429e6c123354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b166afa7f12b1cf350256d9b2c63e2ced75bde8a0dd02c4e7c3ae5ac3fa0fdb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20900441de05dc559f2458efed7d1fd643c31b382d43d1bb27469eaa9b6dd545"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "acme" do
    url "https:files.pythonhosted.orgpackages30caac80099cdcce9486f5c74220dac53e8b35c46afc27288881f4700adfe7f1acme-4.1.1.tar.gz"
    sha256 "0ffaaf6d3f41ff05772fd2b6170cf0b2b139f5134d7a70ee49f6e63ca20e8f9a"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages70b0a35b320e5084821de69a66962513dcc8aa37b7a5bc80e761685533e97be9boto3-1.38.39.tar.gz"
    sha256 "22cca12cfe1b24670de53e3b8f4c69bdf34a2bd3e3363f72393b6b03bb0d78bc"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages096120eceeccdce79ca238453389e9a8a9147a79417a07e22fa6715f1abd6421botocore-1.38.39.tar.gz"
    sha256 "2305f688e9328af473a504197584112f228513e06412038d83205ce8d1456f40"
  end

  resource "certbot" do
    url "https:files.pythonhosted.orgpackagesded76dbaabb3dd61a3a86cad455c65befa7512f1f8c60231f99ed1f2b576770fcertbot-4.1.1.tar.gz"
    sha256 "d1fdde3174bcf1d68f7a8dca070341acec28b78ef92ad2dd18b8d49959e96779"
  end

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

  resource "coloredlogs" do
    url "https:files.pythonhosted.orgpackagesccc7eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages854d6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5dconfigargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "configparser" do
    url "https:files.pythonhosted.orgpackages8bacea19242153b5e8be412a726a70e82c7b5c1537c83f61b20995b2eda3dcd7configparser-7.2.0.tar.gz"
    sha256 "b629cc8ae916e3afbd36d1b3d093f34193d851e11998920fdcfc4552218b7b70"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dns-lexicon" do
    url "https:files.pythonhosted.orgpackages6058055f9552cafeeac094a5e0334fe0eaf4cbf8e1485cc545a26c079ca632f1dns_lexicon-3.21.1.tar.gz"
    sha256 "7cd19f692b384fe5eaa47cce334d24c78ae2eba1d2fb24d2b8a05e04fe294497"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "humanfriendly" do
    url "https:files.pythonhosted.orgpackagescc3f2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "isodate" do
    url "https:files.pythonhosted.orgpackages544de940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "josepy" do
    url "https:files.pythonhosted.orgpackagesa929e7c14150f200c5cd49d1a71b413f61b97406f57872ad693857982c0869c9josepy-2.0.0.tar.gz"
    sha256 "e7d7acd2fe77435cda76092abe4950bb47b597243a8fb733088615fa6de9ec40"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesbfd31cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "localzone" do
    url "https:files.pythonhosted.orgpackagesf91a2406e73b9dedafc761526687a60a09aaa8b0b2f2268aa084c56cbed81959localzone-0.9.8.tar.gz"
    sha256 "23cb6b55a620868700b3f44e93d7402518e08eb7960935b3352ad3905c964597"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "oci" do
    url "https:files.pythonhosted.orgpackages22bd59c6ca3a1789d377fdd7845e6ba0fb3de1618e0f900308285028d0b2a6caoci-2.9.0.tar.gz"
    sha256 "82be4b64456de3b0f7f8051e52d48c0c8b6c499c9c22661b454df459ab7a5632"
  end

  resource "parsedatetime" do
    url "https:files.pythonhosted.orgpackagesa820cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312acparsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pem" do
    url "https:files.pythonhosted.orgpackages058616c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages99b185e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94fprettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages048ccd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "pyotp" do
    url "https:files.pythonhosted.orgpackagesf3b21d5994ba2acde054a443bd5e2d384175449c7d2b6d1a0614dbca3a63abfcpyotp-2.9.0.tar.gz"
    sha256 "346b6642e0dbdde3b4ff5a930b664ca82abfa116356ed48cc42c7d6590d36f63"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackagesf0d26587e8ec3951cbd97c56333d11e0f8a3a4cb64c0d6ed101882b7b31c431fpyrfc3339-2.0.1.tar.gz"
    sha256 "e47843379ea35c1296c3b6c67a948a1a490ae0584edfcbdea0eaffb5dd29960b"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages7297bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1aerequests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages8ca660184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "schedule" do
    url "https:files.pythonhosted.orgpackages0c91b525790063015759f34447d4cf9d2ccb52cdee0f1dd6ff8764e863bcb74cschedule-1.2.2.tar.gz"
    sha256 "15fe9c75fe5fd9b9627f3f19cc0ef1420508f9f9a46f45cd0769ef75ede5f0b7"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "softlayer" do
    url "https:files.pythonhosted.orgpackagesfa5a316006203339a08d3871a1494e75e266e39ba0ccc6cf857d20e05d2fcdc8softlayer-6.2.6.tar.gz"
    sha256 "6e9d874648cbf234d49ee4f5b0829f6bcd4d706adf88318ed1b27a47debc7e5d"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "tencentcloud-sdk-python" do
    url "https:files.pythonhosted.orgpackagesf12856bb71542ec75838643c4479e8188c96d283733b09f7bf790543d553929ctencentcloud-sdk-python-3.0.1405.tar.gz"
    sha256 "c86b6aff1b2100fd4186f4ad139370c4c52ef6120bb532c5393e457224fd9ecd"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages9778182641ea38e3cfd56e9c7b3c0d48a53d432eea755003aa544af96403d4actldextract-5.3.0.tar.gz"
    sha256 "b3d2b70a1594a0ecfa6967d57251527d58e00bb5a91a74387baa0d87a0678609"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "zeep" do
    url "https:files.pythonhosted.orgpackages09354a91181499a1e098cb01e04a26a053714adf2fb1c25b40fdc5f46cfe2e4fzeep-4.3.1.tar.gz"
    sha256 "f45385e9e1b09d5550e0f51ab9fa7c6842713cab7194139372fd82a99c56a06e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "dnsrobocert.yml does not exist", shell_output("#{bin}dnsrobocert -o 2>&1")
  end
end