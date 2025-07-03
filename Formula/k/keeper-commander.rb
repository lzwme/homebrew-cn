class KeeperCommander < Formula
  include Language::Python::Virtualenv

  desc "Command-line and SDK interface to Keeper Password Manager"
  homepage "https:docs.keeper.ioenprivileged-access-managercommander-clioverview"
  url "https:files.pythonhosted.orgpackages4a35946cf22d05714e4b7dfbd5b60fad139f86dc0a583497663d7c31e8e5dca3keepercommander-17.1.2.tar.gz"
  sha256 "ac111f0935f339edd6bb6c166124b6afed6738aff42e2c6daffe615ee676b1f7"
  license "MIT"
  revision 1
  head "https:github.comKeeper-SecurityCommander.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a2cf7b4ce240b0ca2006e593360b475175afbf48b7bc08e574e75945b5efdb1"
    sha256 cellar: :any,                 arm64_sonoma:  "8cb3f62a8b4c17aa43887f3742a4b5ef23da244637e62fb6f32bf4497b7e0861"
    sha256 cellar: :any,                 arm64_ventura: "9fa310cb5be158aad07dd67d6519bb6a515a94f0ac59a5925430c0e8d53058c5"
    sha256 cellar: :any,                 sonoma:        "3778368fdb076f54ec8aa8463c1fb809566d0b01ea6308daeccedee6e833e5c7"
    sha256 cellar: :any,                 ventura:       "e63a116160418551d60c686e72b3f6c4ae9db507335759cddca7105075c52c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0932e4ae26c2d48ef632fc2d0d0363b76cbbc7a7ac3ab21f069ab6f5cc463742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "475502eed4da4c642e2e1000b451ce9fbf2190539348c717d1b9b7a66bb7e093"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # bcrypt dependencies

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "libvpx"
  depends_on "libyaml"
  depends_on "little-cms2"
  depends_on "opus"
  depends_on "python@3.13"
  depends_on "srtp"
  depends_on "webp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "openssl@3"
  end

  on_intel do
    depends_on "libxcb"
    depends_on "openjpeg"
  end

  resource "aioice" do
    url "https:files.pythonhosted.orgpackages95a245dfab1d5a7f96c48595a5770379acf406cdf02a2cd1ac1729b599322b08aioice-0.10.1.tar.gz"
    sha256 "5c8e1422103448d171925c678fb39795e5fe13d79108bebb00aa75a899c2094a"
  end

  resource "aiortc" do
    url "https:files.pythonhosted.orgpackages6203bc947d74c548e0c17cf94e5d5bdacaed0ee9e5b2bb7b8b8cf1ac7a7c01ecaiortc-1.13.0.tar.gz"
    sha256 "5d209975c22d0910fb5a0f0e2caa828f2da966c53580f7c7170ac3a16a871620"
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

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages21289b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ceblinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
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

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages989706afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackages8db96ec8d8ec5715efc6ae39e8694bd48d57c189906f0628558f56688d0447b2fido2-2.0.0.tar.gz"
    sha256 "3061cd05e73b3a0ef6afc3b803d57c826aa2d6a9732d16abd7277361f58e7964"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackagesc0dee47735752347f4128bcf354e0da07ef311a78244eba9e3dc1d4a5ab21a98flask-3.1.1.tar.gz"
    sha256 "284c7b8f2f58cb737f0cf1c30fd7eaf0ccfcde196099d24ecede3fc2005aa59e"
  end

  resource "flask-limiter" do
    url "https:files.pythonhosted.orgpackages707592b237dd4f6e19196bc73007fff288ab1d4c64242603f3c401ff8fc58a42flask_limiter-3.12.tar.gz"
    sha256 "f9e3e3d0c4acd0d1ffbfa729e17198dd1042f4d23c130ae160044fc930e21300"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackages2e5a1124b2c8cb3a8015faf552e92714040bcdbc145dfa29928891b02d147a18fonttools-4.58.4.tar.gz"
    sha256 "928a8009b9884ed3aae17724b960987575155ca23c6f0b8146e400cc9e0d44ba"
  end

  resource "fpdf2" do
    url "https:files.pythonhosted.orgpackageseaa26464c0406365d50bcf000a72c6ede7b6633f08ad8bccdc1553265bb15ccffpdf2-2.8.3.tar.gz"
    sha256 "494dc0bd935271c9ce16fb3a47c98b6f59b8d160cd519c2d3a7ed243c3852456"
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

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "keeper-secrets-manager-core" do
    url "https:files.pythonhosted.orgpackagesc4b21e0fe5d7b64ddb98609a16e35ded1234bd2bb48a67bc302facb27adbdda1keeper_secrets_manager_core-16.6.6.tar.gz"
    sha256 "bda9e733908b34edbac956825fc062e6934894f210d49b0bba1679d167d7be80"
  end

  resource "limits" do
    url "https:files.pythonhosted.orgpackages793295d4908a730213a5db40462b0e20c1b93a688b33eade8c4981bbf0ca08delimits-5.4.0.tar.gz"
    sha256 "27ebf55118e3c9045f0dbc476f4559b26d42f4b043db670afb8963f36cf07fd9"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "ordered-set" do
    url "https:files.pythonhosted.orgpackages4ccabfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2feordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pillow" do
    url "https:files.pythonhosted.orgpackagesf30dd0d6dea55cd152ce3d6767bb38a8fc10e33796ba4ba210cbab9354b6d238pillow-11.3.0.tar.gz"
    sha256 "3828ee7586cd0b2091b6209e5ad53e20d0649bbe87164a459d0676e035e8f523"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages52f3b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8bprotobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackagesc985e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages00dd4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8cpydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pyee" do
    url "https:files.pythonhosted.orgpackages95031fd98d5841cd7964a27d729ccf2199602fe05eb7a405c1462eb7277945edpyee-13.0.0.tar.gz"
    sha256 "b391e3c5a434d1f5118a25615001dbc8f669cf410ab67d04c4d4e07c55481c37"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackagesb077a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pylibsrtp" do
    url "https:files.pythonhosted.orgpackages54c8a59e61f5dd655f5f21033bd643dd31fe980a537ed6f373cdfb49d3a3bd32pylibsrtp-0.12.0.tar.gz"
    sha256 "f5c3c0fb6954e7bb74dc7e6398352740ca67327e6759a199fe852dbc7b84b8ac"
  end

  resource "pyngrok" do
    url "https:files.pythonhosted.orgpackagesb7f807117c60fe37c97fbc7163f8697f289551d618f930801f3b53f1b14b2b7fpyngrok-7.2.11.tar.gz"
    sha256 "9f8890389bd95abc00eca13846c8f485a0db6667dc05987eb98fde343adfb25a"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages048ccd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
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
    url "https:files.pythonhosted.orgpackagesf6b04bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1epython_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages21e626d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages9f6983029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71ewerkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackagesc3fce91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcefwrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackagese3020f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "keepersecurity.com", shell_output("#{bin}keeper server")
  end
end