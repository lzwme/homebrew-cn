class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https:www.ansible.com"
  url "https:files.pythonhosted.orgpackages8adea0a57da24b922bcc2340acbe6c9300e35a6fe132e3e6945333810732cc9cansible-9.3.0.tar.gz"
  sha256 "7f4ea0e4d065538879b3e11e81e85eed4d802d1940f6564ad950e9d11a31b03c"
  license "GPL-3.0-or-later"
  head "https:github.comansibleansible.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "409efe9b072d0ea8a6748dd61fe90851f70238bb0208a9022fb7fafeca48b388"
    sha256 cellar: :any,                 arm64_ventura:  "a74894a34ef07b3c2a414ad0ad63567ce09e8a382fa43e82a382a5aefa9baead"
    sha256 cellar: :any,                 arm64_monterey: "256b586ac8a8624a447f9530e484859cb0f7abac208adf841c578432a2608122"
    sha256 cellar: :any,                 sonoma:         "977c0e7ddf507501ec77f41c0b0d886c30431fe0cf7d049ea5fbace127e16443"
    sha256 cellar: :any,                 ventura:        "5cd3962982332f6854d2f2892af9e918da29061a27696760cc951ac8e5ff99ba"
    sha256 cellar: :any,                 monterey:       "f632c09343ea833f078bc50a89cba0c244b213a4393d6f1f2b2f2ad77b29ac55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9500170fd5ee9b2ec3d493085629527da4053acdf0391756b02178c9579c234"
  end

  # `pkg-config` and `rust` are for bcrypt
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "krb5"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  # pyinotify is linux-only dependency
  resource "pyinotify" do
    on_linux do
      url "https:files.pythonhosted.orgpackagese3c0fd5b18dde17c1249658521f69598f3252f11d9d7a980c5be8619970646e1pyinotify-0.9.6.tar.gz"
      sha256 "9c998a5d7606ca835065cdabc013ae6c66eb9ea76a00a1e3bc6e0cfe2b4f71f4"
    end
  end

  resource "ansible-core" do
    url "https:files.pythonhosted.orgpackagesaf9c12755b9ec6b696701fc7a33e8eab7a78f2b769dc0c966079c9005fffc7bfansible-core-2.16.4.tar.gz"
    sha256 "2cd208b0915948c88bffad331e5d07097b6edca1872cb53375e51b6719e6a060"
  end

  resource "apache-libcloud" do
    url "https:files.pythonhosted.orgpackages1b451a239d9789c75899df8ff53a6b198c1657328f3b333f1711194643d53868apache-libcloud-3.8.0.tar.gz"
    sha256 "75bf4c0b123bc225e24ca95fca1c35be30b19e6bb85feea781404d43c4276c91"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "autopage" do
    url "https:files.pythonhosted.orgpackages9f9e559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages72076a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesdcd123a7ed157ca950a344b2ef814db01c175f970320c4bf1be364ca0c1afdd2boto3-1.34.50.tar.gz"
    sha256 "290952be7899560039cb0042e8a2354f61a7dead0d0ca8bea6ba901930df0468"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages48afd038bd03233fe5c009fd67e8e1bfa6536c3b2ab91737cc629acbff464aa3botocore-1.34.50.tar.gz"
    sha256 "33ab82cb96c4bb684f0dbafb071808e4817d83debc88b223e7d988256370c6d7"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesb34d27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5bcachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cliff" do
    url "https:files.pythonhosted.orgpackagesf6e651643f6e211a4b5eb46b839ef37f2fad6b8b926899bb19bbd2c7c1f01498cliff-4.6.0.tar.gz"
    sha256 "2f38ce8bd1ea4958d66f15b066ac47e65d61f600b9319b921e12e9e9cbcd99d0"
  end

  resource "cmd2" do
    url "https:files.pythonhosted.orgpackages1304b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5ccmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "debtcollector" do
    url "https:files.pythonhosted.orgpackages31e2a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3cdebtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages25147d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bcdocker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "dogpile-cache" do
    url "https:files.pythonhosted.orgpackages94c999a8cc80eace8877845b08bbccc43147afdc9830f604cbd9f8619bfb0409dogpile.cache-1.3.2.tar.gz"
    sha256 "4f71dc0333ad351c9c6f704f5ba2a37bf51c6eed0437d1adf56e075959afe63b"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages9a15ac42556763c08e1b1821a7e55f3a93982c50ca7f25adf8f61a01dd2ed98bgoogle-auth-2.28.1.tar.gz"
    sha256 "34fc3046c257cedcf1622fc4b31fc2be7923d9b4d44973d481125ecc50d83885"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
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
    url "https:files.pythonhosted.orgpackages1d8ccddab0785415c65fef67d5d55078e0c3eb3f7134c3db78a8d6bddec9ff2djunos-eznc-2.7.0.tar.gz"
    sha256 "a45c90641d24ff4c86796418ea76ca64066c06d0bf644d6b77e605bf957c5c7d"
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
    url "https:files.pythonhosted.orgpackagesb85a90d7ae409bdefb9e7cd8e6024e29c33e051e3b20765a12fd88fb963769fekeystoneauth1-5.6.0.tar.gz"
    sha256 "ecb7f34759ebe103db372ab0953c0b821929ddd497f332aa6b3ef6caacffed88"
  end

  resource "kubernetes" do
    url "https:files.pythonhosted.orgpackagesde07d01320a808abaab3426db63476adcb31f7e23fe8c08aef175d7883ea978akubernetes-29.0.0.tar.gz"
    sha256 "c4812e227ae74d07d53c88293e564e54b850452715a59a927e7e1bc6b9a60459"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "ncclient" do
    url "https:files.pythonhosted.orgpackages6ddb887f9002c3e6c8b838ec7027f9d8ac36337f44bcd146c922e3deee60e55encclient-0.6.15.tar.gz"
    sha256 "6757cb41bc9160dfe47f22f5de8cf2f1adf22f27463fb50453cc415ab96773d8"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackages54e60308695af3bd001c7ce503b3a8628a001841fe1def19374c06d4bce9089bnetaddr-1.2.1.tar.gz"
    sha256 "6eb8fedf0412c6d294d06885c110de945cf4d22d2b510d0404f4e06950857987"
  end

  resource "netifaces" do
    url "https:files.pythonhosted.orgpackagesa69186a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "ntc-templates" do
    url "https:files.pythonhosted.orgpackages647e05957b47fc5e15c713b23993df97eea0e218f7d8c8ca4ad90237482267e3ntc_templates-4.3.0.tar.gz"
    sha256 "b6902389e86b868d76b64ea55c8225a0aa7aafe910b3a02b2a33b7b18fb27ef1"
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
    url "https:files.pythonhosted.orgpackages2e5ee5410863ea1fd45107ce23c169acebab54b5e7f6f61af9a7afee49bfec22openstacksdk-3.0.0.tar.gz"
    sha256 "b0c7f9a025d5da92ad4c762941e6acc4cb53930a07ff739a9aebcc5e5a724ae6"
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
    url "https:files.pythonhosted.orgpackages73f9558baa104f8da7d952fe8dc9def38efd2bfc0291e04a4c4e458e4edf17dfosc-lib-3.0.1.tar.gz"
    sha256 "660aa523c5bec9f817671c4b43ac7d4b74f6a1c7f61b38c2ee35fd9384222456"
  end

  resource "oslo-config" do
    url "https:files.pythonhosted.orgpackages9f79d75e9a6234883adc93838602263d394ffaff6b8d315127c98afd596083f6oslo.config-9.4.0.tar.gz"
    sha256 "35b11a661b608edb50305dad91e4e30819d90ef794b7d7dba5bd8b2ef2eb8c0d"
  end

  resource "oslo-context" do
    url "https:files.pythonhosted.orgpackagesbf7c8d43182976b8273a3b49f39526b28da02fcc178cba367f5df7c29c79ef70oslo.context-5.4.0.tar.gz"
    sha256 "e96491bbdd6b51e72a3a8c546a129b84d239e8e9e0b5210c8ba7c0a0a5629919"
  end

  resource "oslo-i18n" do
    url "https:files.pythonhosted.orgpackagesc1d67c48b3444e08a0ef7555747a11cddcadf32437cf3ba45b7722b3ab7b1ae0oslo.i18n-6.3.0.tar.gz"
    sha256 "64a251edef8bf1bb1d4e6f78d377e149d4f15c1a9245de77f172016da6267444"
  end

  resource "oslo-log" do
    url "https:files.pythonhosted.orgpackagesb59b21cb487426ec7e39807a1996ae16325e62230de49f514638bf376ac15a72oslo.log-5.5.0.tar.gz"
    sha256 "4cedd1669c7de28d8e66b67a5f6d6c6fe83928535fa87cd69bf6611b59f567e7"
  end

  resource "oslo-serialization" do
    url "https:files.pythonhosted.orgpackages21ff78cc62d4282cf26d322eedf7409a39f7cd5f8c1a83329dc0a65bfa545bd4oslo.serialization-5.4.0.tar.gz"
    sha256 "315cb3465e99c685cb091b90365cb701bee7140e204ba3e5fc2d8a20b4ec6e76"
  end

  resource "oslo-utils" do
    url "https:files.pythonhosted.orgpackages1d82a81644eea01b60fa3fa32e9d376dd2730da82161be8f68d8805c9f05ec23oslo.utils-7.1.0.tar.gz"
    sha256 "5e42f3394d1f1f976e8994ac4a0918966d2f7eaf7c77380dd612c4a4148dd98e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackagesccaf11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
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
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages19d37cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
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

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages37fe65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44bpyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
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

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-keystoneclient" do
    url "https:files.pythonhosted.orgpackagesb17c8eeff2659a281a9eaf66bf1c754268cdea71510ef4d2a757fcf5ce312a11python-keystoneclient-5.3.0.tar.gz"
    sha256 "bc5e7719f4156425dec77d75c3a79918e3d0b519378a16d8d7efa8849e4c2a79"
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

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "scp" do
    url "https:files.pythonhosted.orgpackagesb650277f788967eed7aa2cbb669ff91dff90d2232bfda95577515a783bbccf73scp-0.14.5.tar.gz"
    sha256 "64f0015899b3d212cb8088e7d40ebaf0686889ff0e243d5c1242efe8b50f053e"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "shade" do
    url "https:files.pythonhosted.orgpackagesb0a6a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages79793ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afasimplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagese7c1b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eecstevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
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
    url "https:files.pythonhosted.orgpackages745be025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "ansible-core" }
    venv.pip_install_and_link resource("ansible-core")
    venv.pip_install_and_link buildpath
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