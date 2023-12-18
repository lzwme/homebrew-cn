class Sickchill < Formula
  include Language::Python::Virtualenv

  desc "Automatic Video Library Manager for TV Shows"
  homepage "https:sickchill.github.io"
  url "https:files.pythonhosted.orgpackagesb009d4fb6080039b1a4a5652e00523e8475119d9b98c5682e20489965e372bdbsickchill-2023.6.27.tar.gz"
  sha256 "1899c3f927f43faabdacdad22b3c8e481c16e51d45f03e206a2c0b63375fdca6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 7
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bbd0b54cadd5932b3f860589f4925050c051940646fe0d79c3c6104241361fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68287d451a7a2e575076be43561884a5a115ce5cec6e0b298c9db8251322bc89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59aef73dc675a0e23efa8fa40ab6c6cb9ca59c6ae902a6e1aaa79d95ec241ed7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b66ffca75850463936be59e1dab3bd451262cfe0562f6a03875bdcdacee55641"
    sha256 cellar: :any_skip_relocation, ventura:        "bbc33a705bc87bd44e0c7b16c9c65654623c60afc7347f169ef76dfcba8af7cb"
    sha256 cellar: :any_skip_relocation, monterey:       "18ff14923e1d474e15845208c2a0a50929a14f2da29b3f592d8e6f55456024d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b872b99d3c5377598165e491f7cfb7e5d3251f7096cec50c42b38aee647bcada"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "babelfish" do
    url "https:files.pythonhosted.orgpackages020de72bf59672ebceae99cd339106df2b0d59964e00a04f7286ae9279d9da6cbabelfish-0.6.0.tar.gz"
    sha256 "2dadfadd1b205ca5fa5dc9fa637f5b7933160a0418684c7c46a7a664033208a2"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "beekeeper-alt" do
    url "https:files.pythonhosted.orgpackages2868b1c59d68275715e5174c0ec0185d3ceca3223933a6a35cda31389438e545beekeeper-alt-2022.9.3.tar.gz"
    sha256 "18addaa163febd69a9e1ec4ec4dddc210785c94c6c1f9b2bcb2a73451b2f23e3"
  end

  resource "bencode-py" do
    url "https:files.pythonhosted.orgpackagese86f1fc1f714edc73a9a42af816da2bda82bbcadf1d7f6e6cae854e7087f579bbencode.py-4.0.0.tar.gz"
    sha256 "2a24ccda1725a51a650893d0b63260138359eaa299bb6e7a09961350a2a6e05c"
  end

  resource "cacheyou" do
    url "https:files.pythonhosted.orgpackages8e6e8a9d13f938789b29e89b78cfeb9d0a9e002c67272ead73060c8306b74fc8cacheyou-23.3.tar.gz"
    sha256 "7e408f15f4978fea2247734b308621f75f7fe169b461679519c72e8a85d61d5d"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6db3aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768bcharset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "cinemagoer" do
    url "https:files.pythonhosted.orgpackages06de3aa6eb738b5c5e39f1909bc080a392842841f9af866edb960de2f22af53ccinemagoer-2023.5.1.tar.gz"
    sha256 "5ce1d77ae6546701618f11e5b1556a19d18edecad1b6d7d96973ec34941b18f2"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deluge-client" do
    url "https:files.pythonhosted.orgpackagesef52f68966132aebea6703caa0b9d12e40581f09725ddf07c97ebb2c4664bb84deluge-client-1.9.0.tar.gz"
    sha256 "0d2f12108a147d44590c8df63997fcb32f8b2fbc18f8cbb221f0136e2e372b85"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "dogpile-cache" do
    url "https:files.pythonhosted.orgpackagesd2f8f3e877361372737d83f6592d6ba2126b2018d2208472a5dcb82773694281dogpile.cache-1.2.2.tar.gz"
    sha256 "fd9022c0d9cbadadf20942391a95adaf296be80b42daa8e202f8de1c21f198b2"
  end

  resource "enzyme" do
    url "https:files.pythonhosted.orgpackagesdd99e4eee822d9390ebf1f63a7a67e8351c09fb7cd75262e5bb1a5256898def9enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackages8f2ecf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ecfuture-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "gntp" do
    url "https:files.pythonhosted.orgpackagesc46cfabf97b5260537065f32a85930eb62776e80ba8dcfed78d4247584fd9aa9gntp-1.0.3.tar.gz"
    sha256 "f4a4f2009ecb8bb41a1aaddd5fb7c03087b2a14cac2c03af029ba04b9166dae0"
  end

  resource "greenlet" do
    url "https:files.pythonhosted.orgpackages54df718c9b3e90edba70fa919bb3aaa5c3c8dabf3a8252ad1e93d33c348e5ca4greenlet-3.0.1.tar.gz"
    sha256 "816bd9488a94cba78d93e1abb58000e8266fa9cc2aa9ccdd6eb0696acb24005b"
  end

  resource "guessit" do
    url "https:files.pythonhosted.orgpackages965f64304acee35bac703cee51656a5caf37bd18c9490561fbff225922f41d39guessit-3.7.1.tar.gz"
    sha256 "2c18d982ee6db30db5d59557add0324a2b49bf3940a752947510632a2b58a3c1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ifaddr" do
    url "https:files.pythonhosted.orgpackagese8acfb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "imagesize" do
    url "https:files.pythonhosted.orgpackagesa78462473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "imdbpy" do
    url "https:files.pythonhosted.orgpackages3057d72563c77f63efe08da5645ab92d5f1dd382f6d3460e0b0c4c4ee7847f1cIMDbPY-2022.7.9.tar.gz"
    sha256 "80a5edf8a87113ff22a44d00fd76d422c42cfeecd4ea820be33753b8f24bf4e6"
  end

  resource "ipaddress" do
    url "https:files.pythonhosted.orgpackagesb99a3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jsonrpclib-pelix" do
    url "https:files.pythonhosted.orgpackagesf510839b1d2cbd6157e4b09d4499c849b48127cd1d761e1d5bfeb1522c8be50djsonrpclib-pelix-0.4.3.2.tar.gz"
    sha256 "e9e0b33efa8fa20d817dd78dfd9e4cdb3967c8a5d3cb5a783be1ee81c4a89c7c"
  end

  resource "kodipydent-alt" do
    url "https:files.pythonhosted.orgpackagesdd776695c399c31ffca5efa10eef3d07fd2b6b24176260477a909d35f0fc1a0bkodipydent-alt-2022.9.3.tar.gz"
    sha256 "61fc4e5565646a799c783bcf5ae7503223513906e3242bff2ecc8aa66dc80826"
  end

  resource "mako" do
    url "https:files.pythonhosted.orgpackages055f2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3eMako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackages8eb364c459af88ea8c2eeb020d0edf3e36c62176e988c47e412133c37c5da5e7markdown2-2.4.10.tar.gz"
    sha256 "cdba126d90dc3aef6f4070ac342f974d63f415678959329cc7909f96cc235d72"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages6d7c59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbfMarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "new-rtorrent-python" do
    url "https:files.pythonhosted.orgpackages18c667a7afff87d09baa7f43f35e94722a5affc4f0f9bd54671cf02008d9c6dfnew-rtorrent-python-1.0.1a0.tar.gz"
    sha256 "7a9319d6006b98bab66e68fbd79ec353c81c6e1aea2197a4e9097fd2760d3cfb"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages02d8acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "profilehooks" do
    url "https:files.pythonhosted.orgpackagesf77325ef2a50d78a463297228e85e0b1e34099a774c54ec169c21b1f5e5152c6profilehooks-1.12.0.tar.gz"
    sha256 "05b87589df8a8c630fd701bae6008cc1cfff4457bd0064887ad25248327a5ba3"
  end

  resource "putio-py" do
    url "https:files.pythonhosted.orgpackages7a63af072aadbb7fb643588e41dd8b434ee47238fcb15f04976101fae38b1b12putio.py-8.7.0.tar.gz"
    sha256 "ecfbedeada74a2c7540a665c4d5b9bb147b32fbdb90c40149e65b3786f0e7300"
  end

  resource "pygithub" do
    url "https:files.pythonhosted.orgpackagesfb30203d3420960853e399de3b85d6613cea1cf17c1cf7fc9716f7ee7e17e0fcPyGithub-1.59.1.tar.gz"
    sha256 "c44e3a121c15bf9d3a5cc98d94c9a047a5132a9b01d22264627f58ade9ddc217"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pynma" do
    url "https:files.pythonhosted.orgpackages6e9437a7ee7b0b8adec69797c3ac1b9a158f6b1ecb608bfe289d155c3b4fc816PyNMA-1.0.tar.gz"
    sha256 "f90a7f612d508b628daf022068967d2a103ba9b2355b53df12600b8e86ce855b"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "pysrt" do
    url "https:files.pythonhosted.orgpackages311a0d858da1c6622dcf16011235a2639b0a01a49cecf812f8ab03308ab4de37pysrt-1.1.2.tar.gz"
    sha256 "b4f844ba33e4e7743e9db746492f3a193dc0bc112b153914698e7c1cdeb9b0b9"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https:files.pythonhosted.orgpackagesde630f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "python-twitter" do
    url "https:files.pythonhosted.orgpackages59635941b988f1a119953b046ae820bc443ada3c9e0538a80d67f3938f9418f1python-twitter-3.5.tar.gz"
    sha256 "45855742f1095aa0c8c57b2983eee3b6b7f527462b50a2fa8437a8b398544d90"
  end

  resource "python3-fanart" do
    url "https:files.pythonhosted.orgpackages2e55d09b26a5c3bc41e9b92cba5342f1801ea9e8c1bec0862a428401e24dfd19python3-fanart-2.0.0.tar.gz"
    sha256 "8bfb0605ced5be0123c9aa82c392e8c307e9c65bff47d545d6413bbb643a4a74"
  end

  resource "qbittorrent-api" do
    url "https:files.pythonhosted.orgpackages33edaaf1de8d72ac155006c9733a7d0623a30dec2e16e1e86d2f8a369bcc5e8fqbittorrent-api-2023.10.54.tar.gz"
    sha256 "c421c1fe93d445cd7ebe37ba22104767a1e8814b2661f044f7defb42dc28736c"
  end

  resource "rarfile" do
    url "https:files.pythonhosted.orgpackagesd7eeb3f1e882c4fcfaf3a33bb12d5ef77d7f1b92474628d2aedcab231a21cfb4rarfile-4.1.tar.gz"
    sha256 "db60b3b5bc1c4bdeb941427d50b606d51df677353385255583847639473eda48"
  end

  resource "rebulk" do
    url "https:files.pythonhosted.orgpackagesf20624c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages9552531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49frequests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "send2trash" do
    url "https:files.pythonhosted.orgpackages4ad2d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "sqlalchemy" do
    url "https:files.pythonhosted.orgpackagesaee247f40dc06472df5a906dd8eb9fe4ee2eb1c6b109c43545708f922b406accSQLAlchemy-2.0.22.tar.gz"
    sha256 "5434cc601aa17570d79e5377f5fd45ff92f9379e2abed0be5e8c2fba8d353d2b"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesacd677387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "subliminal" do
    url "https:files.pythonhosted.orgpackagesdd3aac02011988ad013f24a11cb6123a7ff9e17a75369964c7edd9f64bfea80fsubliminal-2.1.0.tar.gz"
    sha256 "c6439cc733a4f37f01f8c14c096d44fd28d75d1f6f6e2d1d1003b1b82c65628b"
  end

  resource "text-unidecode" do
    url "https:files.pythonhosted.orgpackagesabe2e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  # upstream issue report, https:github.comhustcctimeagoissues45
  resource "timeago" do
    url "https:github.comhustcctimeagoarchiverefstags1.0.16.tar.gz"
    sha256 "7b54b88b3d0566cbf01ca11077dad8f7ae07a4318479e3d1b30feebe85f7137f"
  end

  resource "tmdbsimple" do
    url "https:files.pythonhosted.orgpackagesa1873309cb03df1c9f9895fccd87e9875050f19e2cfec5a50b9d72e50d420fc8tmdbsimple-2.9.1.tar.gz"
    sha256 "636eaaaec82027929e8a91c2166e01f552ec63f869bf1fcd65aa561b705c7464"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackages4864679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  resource "tus-py" do
    url "https:files.pythonhosted.orgpackages543c266c0aadca8969b8f4832e4975a86afe9c869b3ee6918a408b03619746d6tus.py-1.3.4.tar.gz"
    sha256 "b80feda87700aae629eb19dd98cec68ae520cd9b2aa24bd0bab2b777be0b4366"
  end

  resource "tvdbsimple" do
    url "https:files.pythonhosted.orgpackages737db8e4d5c5473d6f9a492bf30916fdbf96f06034e6d23fde31ccb86704e41ctvdbsimple-1.0.6.tar.gz"
    sha256 "a8665525fa8b7aaf1e15fc3eec18b6f181582e25468830f300ab3809dbe948fe"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackages805df156f6a7254ecc0549de0eb75f786d2df724c0310b97c825383517d2c98dUnidecode-1.3.7.tar.gz"
    sha256 "3c90b4662aa0de0cb591884b934ead8d2225f1800d8da675a7750cbc3bd94610"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "validators" do
    url "https:files.pythonhosted.orgpackages9514ed0af6865d378cfc3c504aed0d278a890cbefb2f1934bf2dbe92ecf9d6b1validators-0.20.0.tar.gz"
    sha256 "24148ce4e64100a2d5e267233e23e7afeb55316b47d30faae7eb6e7292bc226a"
  end

  resource "win-inet-pton" do
    url "https:files.pythonhosted.orgpackagesd9da0b1487b5835497dea00b00d87c2aca168bb9ca2e2096981690239e23760awin_inet_pton-1.1.0.tar.gz"
    sha256 "dd03d942c0d3e2b1cf8bab511844546dfa5f74cb61b241699fa379ad707dea4f"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackagesf87d73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages390d40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7fxmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin"sickchill", "--datadir", var"sickchill", "--quiet", "--nolaunch"]
    keep_alive true
    working_dir var"sickchill"
  end

  test do
    begin
      port = free_port.to_s

      pid = fork do
        exec bin"sickchill", "--port", port, "--datadir", testpath, "--nolaunch"
      end
      sleep 30
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
    assert_predicate testpath"config.ini", :exist?
    assert_predicate testpath"sickchill.db", :exist?
  end
end