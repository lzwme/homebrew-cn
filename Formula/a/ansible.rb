class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https:www.ansible.com"
  url "https:files.pythonhosted.orgpackagesebabe6993e1608fa911ee84dd0f29f494064f3b7f4a277f99608c9421a7a5ed4ansible-9.1.0.tar.gz"
  sha256 "5ad94991fb0e0e53a770a9ffcf1b68047f61b2282d948a7d2682ecd8fb8fa1bf"
  license "GPL-3.0-or-later"
  head "https:github.comansibleansible.git", branch: "devel"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "17267459f8bc9a9b5578818aaaf28b17f813f5229e4b7a2312178beebb9da987"
    sha256 cellar: :any,                 arm64_ventura:  "0198d621e983cc17086d7c7cbb2fa5a22d42c441640e05d11a8a92764e8acf10"
    sha256 cellar: :any,                 arm64_monterey: "94f172b361ade2430a77712580030b543bad250babbbe91579454ed77032fc1e"
    sha256 cellar: :any,                 sonoma:         "fc8b4c93ffc9a6fd3dced7f811e3c102198b9c681bb7aff4a1566e214462f12f"
    sha256 cellar: :any,                 ventura:        "1c1673127cbc8acc162be759ccd8fdd86dbc29bae60bb7bfd9485bf8cf98d1e1"
    sha256 cellar: :any,                 monterey:       "fe3f8c0792df076396a4b2ab3cdb0c2ce7524429a576ad1b6efdc29616f609a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5bb3958b7639c47b1a9c2540e2f895ae19b7ef38744737524e675dfa75b87de"
  end

  # `pkg-config` and `rust` are for bcrypt
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-lxml"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "krb5"

  # pyinotify is linux-only dependency
  resource "pyinotify" do
    on_linux do
      url "https:files.pythonhosted.orgpackagese3c0fd5b18dde17c1249658521f69598f3252f11d9d7a980c5be8619970646e1pyinotify-0.9.6.tar.gz"
      sha256 "9c998a5d7606ca835065cdabc013ae6c66eb9ea76a00a1e3bc6e0cfe2b4f71f4"
    end
  end

  resource "ansible-core" do
    url "https:files.pythonhosted.orgpackages665f3098fac361ca16fc42ac30a2da09939286afd9af289f156ac9fbe87595e9ansible-core-2.16.2.tar.gz"
    sha256 "e4ab559e7e525b1c6f99084fca873bb014775d5ecbe845b7c07b8e9d6c9c048b"
  end

  resource "apache-libcloud" do
    url "https:files.pythonhosted.orgpackages1b451a239d9789c75899df8ff53a6b198c1657328f3b333f1711194643d53868apache-libcloud-3.8.0.tar.gz"
    sha256 "75bf4c0b123bc225e24ca95fca1c35be30b19e6bb85feea781404d43c4276c91"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "autopage" do
    url "https:files.pythonhosted.orgpackages9f9e559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagesdf56be5fda8e6fc05123c8c9f526095e93d0802a0a0b2beaf995ee2cc20aa2f8bcrypt-4.1.1.tar.gz"
    sha256 "df37f5418d4f1cdcff845f60e747a015389fa4e63703c918330865e06ad80007"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages121f1d4c5bbe89542b62ec6a6ba624ef0142e1d0c3267711b4f01f6258399a0aboto3-1.33.8.tar.gz"
    sha256 "d02a084b25aa8d46ef917b128e90877efab1ba45f9d1ba3a11f336930378e350"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages6b7650a205081387fe61194bfa4992d9ea2067309074ac89a5aeaac5481581edbotocore-1.33.8.tar.gz"
    sha256 "e6970bf89cbe2624399aeffce52c253917d8e5a1c671de4054557603ab56c922"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages10211b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cliff" do
    url "https:files.pythonhosted.orgpackages8a310fe8226a7f6e0c99f9d850c3dc0f931c24f91daf0d742f3d5cb867d8d416cliff-4.4.0.tar.gz"
    sha256 "aa8d404aa2d6b4d8639c61bd6dc47acb3656ebc3fc025b1b7bb07af2baef785f"
  end

  resource "cmd2" do
    url "https:files.pythonhosted.orgpackages1304b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5ccmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "debtcollector" do
    url "https:files.pythonhosted.orgpackagesc87d904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211adebtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages652d372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackagesf073f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5edocker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "dogpile-cache" do
    url "https:files.pythonhosted.orgpackagesd2f8f3e877361372737d83f6592d6ba2126b2018d2208472a5dcb82773694281dogpile.cache-1.2.2.tar.gz"
    sha256 "fd9022c0d9cbadadf20942391a95adaf296be80b42daa8e202f8de1c21f198b2"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackages8f2ecf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ecfuture-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages29cfc34598e601223a049cdefb343c4958a7ebfe4663c689e8efe8d24fe8c33fgoogle-auth-2.25.1.tar.gz"
    sha256 "d5d66b8f4f6e3273740d7bb73ddefa6c2d1ff691704bd407d51c6b5800e7c97b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesdb5a392426ddb5edfebfcb232ab7a47e4a827aa1d5b5267a5c20c448615feaa9importlib_metadata-7.0.0.tar.gz"
    sha256 "7fc841f8b8332803464e5dc1c63a2e59121f46ca186c0e2e182e80bf8c1319f7"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https:files.pythonhosted.orgpackages427818813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages8f5e67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bcjsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "junos-eznc" do
    url "https:files.pythonhosted.orgpackages07c134866adbd43cfdbe1472d919ee05cabf7b77ef5f61f0419a27775ef1dc7ajunos-eznc-2.6.8.tar.gz"
    sha256 "80772346552225b78b6e9812bc791f67735b7e76e753dea5b7cfe888ef40e0a1"
  end

  resource "jxmlease" do
    url "https:files.pythonhosted.orgpackages8d6ab2944628e019c753894552c1499bf60e2cef9efea138756c5d66f0d5eb98jxmlease-1.0.3.tar.gz"
    sha256 "612c1575d8a87026dea096bb75acec7302dd69040fa23d9116e71e30d5e0839e"
  end

  resource "kerberos" do
    url "https:files.pythonhosted.orgpackages39cdf98699a6e806b9d974ea1d3376b91f09edcb90415adbf31e3b56ee99ba64kerberos-1.3.1.tar.gz"
    sha256 "cdd046142a4e0060f96a00eb13d82a5d9ebc0f2d7934393ed559bac773460a2c"
  end

  resource "keystoneauth1" do
    url "https:files.pythonhosted.orgpackages7a280b760f26f0c33c48aec42003c8a9ea96b0bc409d7fb892593ee30f272a9fkeystoneauth1-5.4.0.tar.gz"
    sha256 "1ac134151ceb02e50b68ad78dec9821bf89fe53bd36fc8658501c47b07cbdf53"
  end

  resource "kubernetes" do
    url "https:files.pythonhosted.orgpackages3c5ed27f39f447137a9a3d1f31142c77ce74bcedfda7dafe922d725c7ef2da33kubernetes-28.1.0.tar.gz"
    sha256 "1468069a573430fb1cb5ad22876868f57977930f80a6749405da31cd6086a7e9"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  # pin to 0.6.15 for py3.12 support
  resource "ncclient" do
    url "https:files.pythonhosted.orgpackages6ddb887f9002c3e6c8b838ec7027f9d8ac36337f44bcd146c922e3deee60e55encclient-0.6.15.tar.gz"
    sha256 "6757cb41bc9160dfe47f22f5de8cf2f1adf22f27463fb50453cc415ab96773d8"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackages484c2491bfdb868c3f40d985037fa64a3903c125f45d7d3025640e05715db7a3netaddr-0.9.0.tar.gz"
    sha256 "7b46fa9b1a2d71fd5de9e4a3784ef339700a53a08c8040f08baf5f1194da0128"
  end

  resource "netifaces" do
    url "https:files.pythonhosted.orgpackagesa69186a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "ntc-templates" do
    url "https:files.pythonhosted.orgpackages5502bb4c152beb52a24e020a494c5f1f768b9e18fa12b6c6d0fd5056d020656dntc_templates-4.0.1.tar.gz"
    sha256 "5bd158592ac99e769a0b7e82e53fd714a410f912fc9e438e95cc0130cf7290a8"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "openshift" do
    url "https:files.pythonhosted.orgpackages55f69e2e4935b59726bff3d53da35afba3904fe9ed693efedd6b7bbddff6cc78openshift-0.13.2.tar.gz"
    sha256 "f55789fce56fcbf7e2cd9377a68c4a99ab406074d3324b9abcca98477d101471"
  end

  resource "openstacksdk" do
    url "https:files.pythonhosted.orgpackages3163d161a1c96fd7c3210cb708f018ab0869b2b70c99095875d1362a86103331openstacksdk-2.0.0.tar.gz"
    sha256 "697cb62515c548d3b7fc5cb3f865e279b930d39e37dceb11d871f81f9fa591e8"
  end

  resource "os-client-config" do
    url "https:files.pythonhosted.orgpackages58beba2e4d71dd57653c8fefe8577ade06bf5f87826e835b3c7d5bb513225227os-client-config-2.1.0.tar.gz"
    sha256 "abc38a351f8c006d34f7ee5f3f648de5e3ecf6455cc5d76cfd889d291cdf3f4e"
  end

  resource "os-service-types" do
    url "https:files.pythonhosted.orgpackages583f09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ecos-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "osc-lib" do
    url "https:files.pythonhosted.orgpackages6c46796a178cc7ae4f1cd030e503db68ab7cf4474211ca796f7a887a0569f49dosc-lib-2.9.0.tar.gz"
    sha256 "36757a0164d661326141ad2bb489a6887455a6f542415af37334bf1deb0f0f9b"
  end

  resource "oslo-config" do
    url "https:files.pythonhosted.orgpackages86df3806c478e29866001cd0e04f22a9688851928a2da830aceb5a026d125a40oslo.config-9.2.0.tar.gz"
    sha256 "ffeb01ca65a603d5525905f1a88a3319be09ce2c6ac376c4312aaec283095878"
  end

  resource "oslo-context" do
    url "https:files.pythonhosted.orgpackagesbdaa6ffc977bc9503318d8992530b249113092aaa83961490991b24783829f5aoslo.context-5.3.0.tar.gz"
    sha256 "c5107141c628b6ae56d4feb6322b9c4a70092fd6a181e91fabeade94a09e4e38"
  end

  resource "oslo-i18n" do
    url "https:files.pythonhosted.orgpackagesa424c4c441628dee6f6a34b8a433fb1e12853f066f9d0a0c7b7cf88cb8547b10oslo.i18n-6.2.0.tar.gz"
    sha256 "70f8a4ce9871291bc609d07e31e6e5032666556992ff1ae53e78f2ed2a5abe82"
  end

  resource "oslo-log" do
    url "https:files.pythonhosted.orgpackages2bd5b3b9a02d09eb0b7c9d05958908b881e23182dac95d448377eb564598e52foslo.log-5.4.0.tar.gz"
    sha256 "2eb355b58570f25811da76fa81453b875c7c944a19a23d2c305b4a4dfebbd223"
  end

  resource "oslo-serialization" do
    url "https:files.pythonhosted.orgpackages1d75dff75372e7af48468da06f52c6a9abca63b7a4000165ce49e161011a4a10oslo.serialization-5.2.0.tar.gz"
    sha256 "9cf030d61a6cce1f47a62d4050f5e83e1bd1a1018ac671bb193aee07d15bdbc2"
  end

  resource "oslo-utils" do
    url "https:files.pythonhosted.orgpackagesdd64453052c33d834e4b187e5459e7a3f8ae67134d321de96aa0bd3e918c9bf2oslo.utils-6.3.0.tar.gz"
    sha256 "758d945b2bad5bea81abed80ad33ffea1d1d793348ac5eb5b3866ba745b11d55"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages4403158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "passlib" do
    url "https:files.pythonhosted.orgpackagesb6069da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages8dc2ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackagese1c05e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386bprettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "proxmoxer" do
    url "https:files.pythonhosted.orgpackages00dd629ec9dfdab26a75e3120403231bf3dc3ecda3ebe36db72c829ae30cbfcaproxmoxer-2.0.1.tar.gz"
    sha256 "088923f1a81ee27631e88314c609bfe22b33d8a41271b5f02e86f996f837fe31"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackagesa72c4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pysphere3" do
    url "https:files.pythonhosted.orgpackagesfa1e16cf889e0e38380678631a4afebeeb840cb29f54f11413356770efe29240pysphere3-0.1.8.tar.gz"
    sha256 "c8efe92e7802b59ef67e09fb20b008fc1bd0d253ba97ba689aa892b125283ae1"
  end

  resource "pyspnego" do
    url "https:files.pythonhosted.orgpackages3ac3401a5ae889b51f80e91474b6acda7dae8d704c6fe8424fd40e0ff0702812pyspnego-0.10.2.tar.gz"
    sha256 "9a22c23aeae7b4424fdb2482450d3f8302ac012e2644e1cfe735cf468fcd12ed"
  end

  resource "python-consul" do
    url "https:files.pythonhosted.orgpackages7f06c12ff73cb1059c453603ba5378521e079c3f0ab0f0660c410627daca64b7python-consul-1.1.0.tar.gz"
    sha256 "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4"
  end

  resource "python-keystoneclient" do
    url "https:files.pythonhosted.orgpackages13c3456c3d3125a189adf7d23e7ca7759226d717fdce20c6c590686d03886897python-keystoneclient-5.2.0.tar.gz"
    sha256 "72a42c3869e2128bb0c626ac856c3dbf3e38ef16d7e85dd35567b82cd24539a9"
  end

  resource "python-neutronclient" do
    url "https:files.pythonhosted.orgpackages1e2dc58cc8c8831fc433d415f3d30f5a84a5da0ade1e16e20fee962d4e4fa7b8python-neutronclient-11.1.0.tar.gz"
    sha256 "f0a5cd6e3d8ce5a26fb0f88a932148a7a304148f6d8c68bc58e9ba1cc38d7798"
  end

  resource "python-string-utils" do
    url "https:files.pythonhosted.orgpackages10918c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pywinrm" do
    url "https:files.pythonhosted.orgpackages7cba78329e124138f8edf40a41b4252baf20cafdbea92ea45d50ec712124e99bpywinrm-0.4.3.tar.gz"
    sha256 "995674bf5ac64b2562c9c56540473109e530d36bde10c262d5a5296121ad5565"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-credssp" do
    url "https:files.pythonhosted.orgpackagesbcc3de13b8598287440ab1df7eba97b93278d309dffb920f0163a09e089b71ecrequests-credssp-2.0.0.tar.gz"
    sha256 "229afe2f6e1c9fabef64fc2bdf2a10e794ca6c4a0c00a687d53fbfaf7b8ee71d"
  end

  resource "requests-ntlm" do
    url "https:files.pythonhosted.orgpackages7aad486a6ca1879cf1bb181e3e4af4d816d23ec538a220ef75ca925ccb7dd31drequests_ntlm-1.2.0.tar.gz"
    sha256 "33c285f5074e317cbdd338d199afa46a7c01132e5c111d36bd415534e9b916a8"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages9552531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49frequests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "requestsexceptions" do
    url "https:files.pythonhosted.orgpackages82ed61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "resolvelib" do
    url "https:files.pythonhosted.orgpackagesce10f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rfc3986" do
    url "https:files.pythonhosted.orgpackages85401520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages5fcc7e3b8305e22d7dcb383d4e1a30126cfac3d54aea2bbd2dfd147e2eff4988s3transfer-0.8.2.tar.gz"
    sha256 "368ac6876a9e9ed91f6bc86581e319be08188dc60d50e0d56308ed5765446283"
  end

  resource "scp" do
    url "https:files.pythonhosted.orgpackagesb650277f788967eed7aa2cbb669ff91dff90d2232bfda95577515a783bbccf73scp-0.14.5.tar.gz"
    sha256 "64f0015899b3d212cb8088e7d40ebaf0686889ff0e243d5c1242efe8b50f053e"
  end

  resource "shade" do
    url "https:files.pythonhosted.orgpackagesb0a6a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages79793ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afasimplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesacd677387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "textfsm" do
    url "https:files.pythonhosted.orgpackagesb8bfc9147d29c5a3ff4c1c876e16ea02f6d4e4f35ba1bcbb2ac80a254924f0aatextfsm-1.1.3.tar.gz"
    sha256 "577ef278a9237f5341ae9b682947cefa4a2c1b24dbe486f94f2c95addc6504b5"
  end

  resource "transitions" do
    url "https:files.pythonhosted.orgpackagesbcc0d2e5b8a03ad07c10694ab0804682722b9293fbe89391a8508aff1f6d9603transitions-0.9.0.tar.gz"
    sha256 "2f54d11bdb225779d7e729011e93a9fb717668ce3dc65f8d4f5a5d7ba2f48e10"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages70e581f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420dtzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagesd71263deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackages20072a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages390d40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7fxmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yamlordereddictloader" do
    url "https:files.pythonhosted.orgpackages2378f853b0db6d8f3ea0ae4c648e4504ba376d024c139ba1292a256ce6180dd0yamlordereddictloader-0.4.2.tar.gz"
    sha256 "36af2f6210fcff5da4fc4c12e1d815f973dceb41044e795e1f06115d634bca13"
  end

  resource "zabbix-api" do
    url "https:files.pythonhosted.orgpackages4ace893d6ab7e978d0c00d9154c0cf385016b862438da069302e7ceac0f6c429zabbix-api-0.5.6.tar.gz"
    sha256 "627ad26769b6831130239182afcb195f64fbf494626bc9eb4b2ac8170de5b775"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    skipped = %w[ansible-core junos-eznc]
    venv.pip_install resources.reject { |r| skipped.include? r.name }
    venv.pip_install_and_link resource("ansible-core")
    venv.pip_install_and_link buildpath

    # Support python3.12. Remove when fixed upstream.
    # https:github.comJuniperpy-junos-ezncissues1276
    resource("junos-eznc").stage do
      inreplace "setup.py", "version=versioneer.get_version(),", "version='#{resource("junos-eznc").version}',"
      inreplace "setup.py", "cmdclass=versioneer.get_cmdclass(),", "#cmdclass=versioneer.get_cmdclass(),"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath"tmp"
    (testpath"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    (testpath"hosts.ini").write [
      "localhost ansible_connection=local",
      " ansible_python_interpreter=#{which(python3)}",
      "\n",
    ].join
    system bin"ansible-playbook", testpath"playbook.yml", "-i", testpath"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https:mozilla-modern.badssl.com')"
    system libexec"binpython", "-c", script

    # Ensure ansible-vault can encryptdecrypt files.
    (testpath"vault-password.txt").write("12345678")
    (testpath"vault-test-file.txt").write <<~EOS
      ---
      content:
        hello: world
    EOS
    system bin"ansible-vault", "encrypt",
           "--vault-password-file", testpath"vault-password.txt",
           testpath"vault-test-file.txt"
    system bin"ansible-vault", "decrypt",
           "--vault-password-file", testpath"vault-password.txt",
           testpath"vault-test-file.txt"

    # Check ansible-test is happy with our python version
    mkdir "ansible_collectionscommunitygeneral" do
      output = shell_output("#{bin}ansible-test sanity --list-tests 2>&1")
      assert_match "WARNING: All targets skipped.", output
    end
  end
end