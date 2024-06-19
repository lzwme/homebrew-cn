class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https:www.ansible.com"
  url "https:files.pythonhosted.orgpackages32e83bbd91286c1b858afafac59a4f582c5f0344efabb4f4e013de9d1d9c21c2ansible-10.1.0.tar.gz"
  sha256 "7d8c44557f570687306e19d0e3296ad230593cb12bda35dcfc9274a6063af22a"
  license "GPL-3.0-or-later"
  head "https:github.comansibleansible.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae32a306279ee598cb34eaa2146dbe1b42848b0a00ece94cf76257ce138adc44"
    sha256 cellar: :any,                 arm64_ventura:  "ec36b778da3e521aad5b9286ebb9b1b82c3a258716f9580a3cfc0eaee9bbe11c"
    sha256 cellar: :any,                 arm64_monterey: "c32190ac48353c4ebdfe7117174644e8bade2df619e9ad2f94b1d00018bd614d"
    sha256 cellar: :any,                 sonoma:         "1a5a0b6913911a1b0f3f69e9c8fd78a59d77d1e3aa70566ae96bc520779454b0"
    sha256 cellar: :any,                 ventura:        "38acede110e7de1e38f1e2bbed0f5b7d40d3fbd4226025868f60af4505264ab4"
    sha256 cellar: :any,                 monterey:       "01d2d7a8c22512551e0849ea237fa51e634b7f37ed7104ccafba6e45659bd3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "855a3a5cd291401432382db2d06e484926e1f0380f5105aa72c378dc62e442aa"
  end

  # `pkg-config` and `rust` are for bcrypt
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libssh"
  depends_on "libyaml"
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
    url "https:files.pythonhosted.orgpackagesc476e7b0ac590ef1f100fef0ae6875dbbab06d74edfac8b050024ef28cab1c3dansible_core-2.17.1.tar.gz"
    sha256 "46449d71bbd17c3ce85fe379721d88d333fd23637b5c3798e83fae5fa38def00"
  end

  resource "ansible-pylibssh" do
    url "https:files.pythonhosted.orgpackages18bab26b441cf16037170b6e75bb68e7cfc8a10460476dce50cab618502eb922ansible-pylibssh-1.2.0.post4.tar.gz"
    sha256 "6eb9d2af34a7ba62b7dbf98438dd25d2248f76862b17062605ce0c4fb59cad7f"
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
    url "https:files.pythonhosted.orgpackagescae90b36987abbcd8c9210c7b86673d88ff0a481b4610630710fb80ba5661356bcrypt-4.1.3.tar.gz"
    sha256 "2ee15dd749f5952fe3f0430d0ff6b74082e159c50332a1413d51b5689cf06623"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages81f50c7d1b745462d9fe0c2b4709dc6a4b1cbe399c02ad60b26ae2837714d455boto3-1.34.128.tar.gz"
    sha256 "43a6e99f53a8d34b3b4dbe424dbcc6b894350dc41a85b0af7c7bc24a7ec2cead"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9ec9844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
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
    url "https:files.pythonhosted.orgpackages3c1c213ba67600827d8c8cb2b30f1e5471e298b766505341b7fe7c8486cdc388cliff-4.7.0.tar.gz"
    sha256 "6ca45f8df519bbc0722c61049de7b7e442a465fa7f3f552b96d735fa26fd5b26"
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
    url "https:files.pythonhosted.orgpackages919b4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83cedocker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "dogpile-cache" do
    url "https:files.pythonhosted.orgpackages813b83ce66995ce658ad63b86f7ca83943c466133108f20edc7056d4e0f41347dogpile.cache-1.3.3.tar.gz"
    sha256 "f84b8ed0b0fb297d151055447fa8dcaf7bae566d4dbdefecdcc1f37662ab588b"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackagesbef6b22ef3a4b24b5b0d0fcf8426080eab66ccdfaaf73a61e37e76693c43f7f6google-auth-2.30.0.tar.gz"
    sha256 "ab630a1320f6720909ad76a7dbdb6841cdf5c66b328d690027e4867bdfb16688"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https:files.pythonhosted.orgpackages6a0aeebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "junos-eznc" do
    url "https:files.pythonhosted.orgpackagescec60dde3625873312c8a337334f0998491a07dfa71f378f25bf0e0cdd13eb5fjunos-eznc-2.7.1.tar.gz"
    sha256 "371f0298bf03e0cb4c017c43f6f4122263584eda0d690d0112e93f13daae41ac"
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
    url "https:files.pythonhosted.orgpackages823c9f29f6cab7f35df8e54f019e5719465fa97b877be2454e99f989270b4f34kubernetes-30.1.0.tar.gz"
    sha256 "41e4c77af9f28e7a6c314e3bd06a8c6229ddd787cad684e0ab9f69b498e98ebc"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages084c17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "ncclient" do
    url "https:files.pythonhosted.orgpackages6ddb887f9002c3e6c8b838ec7027f9d8ac36337f44bcd146c922e3deee60e55encclient-0.6.15.tar.gz"
    sha256 "6757cb41bc9160dfe47f22f5de8cf2f1adf22f27463fb50453cc415ab96773d8"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackages5490188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229dnetaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "netifaces" do
    url "https:files.pythonhosted.orgpackagesa69186a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "ntc-templates" do
    url "https:files.pythonhosted.orgpackagesa6206cc8564322c713d8ebecab26cf25c7a0e99265b56c32c3d79c0868022638ntc_templates-5.1.0.tar.gz"
    sha256 "820583f35a8d7411c86b70635a6acd65ce357b8bc19e1f408ce836eac30a6371"
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
    url "https:files.pythonhosted.orgpackages82c65cd4b199e39a2b9bad1162d925a362b46d5164de7cd34a2a7f1dd8094cedopenstacksdk-3.1.0.tar.gz"
    sha256 "707f15d7ec074ab2434b9a5e1984facab00f822d272f4c2a5de0d22a09eb79cd"
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
    url "https:files.pythonhosted.orgpackagesf69f0f4d315c5ea8cd7fc83fc6416d952a6fffa4094ad17e59745932f78794fboslo.context-5.5.0.tar.gz"
    sha256 "eae0317b29928f1934df4c60b860fe8625247cb297c5cc62fef8eb5827b12fac"
  end

  resource "oslo-i18n" do
    url "https:files.pythonhosted.orgpackagesc1d67c48b3444e08a0ef7555747a11cddcadf32437cf3ba45b7722b3ab7b1ae0oslo.i18n-6.3.0.tar.gz"
    sha256 "64a251edef8bf1bb1d4e6f78d377e149d4f15c1a9245de77f172016da6267444"
  end

  resource "oslo-log" do
    url "https:files.pythonhosted.orgpackages67d1015096ac228990e0410347cc27ee759d5d27d4074f6041b9d2f1e994ee28oslo.log-6.0.0.tar.gz"
    sha256 "89f0d6fa2cba8281f89b508a7fe49bfb97daaf55c5278187d45a3069971e687f"
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
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
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
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
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
    url "https:files.pythonhosted.orgpackages2b013b26738ad7c675d558d71598bab5738750bd17877d3205cef7a8a680e7fcpyspnego-0.11.0.tar.gz"
    sha256 "17dda4fbf725094c440e68709601c1575db83d9c844c9efedf0ad4dd1b72e5a0"
  end

  resource "python-consul" do
    url "https:files.pythonhosted.orgpackages7f06c12ff73cb1059c453603ba5378521e079c3f0ab0f0660c410627daca64b7python-consul-1.1.0.tar.gz"
    sha256 "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-keystoneclient" do
    url "https:files.pythonhosted.orgpackages106716b204d96216c57606b352388283fb743e09d85560860ca666baf4876210python-keystoneclient-5.4.0.tar.gz"
    sha256 "b2b4bdbe9daf7b0b353b8807672eeed01f87dd03b4f8b42d0d061b09b8931f41"
  end

  resource "python-neutronclient" do
    url "https:files.pythonhosted.orgpackages1ac52db2e25e059f01ea8b85cea9c11cdaf54970f5ea64e6c5ea124c241bc98dpython-neutronclient-11.3.0.tar.gz"
    sha256 "0a2eae368639d7b507173f99a9e6cd706cddfc8cb7840e84a59df52dc5fde951"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-credssp" do
    url "https:files.pythonhosted.orgpackagesbcc3de13b8598287440ab1df7eba97b93278d309dffb920f0163a09e089b71ecrequests-credssp-2.0.0.tar.gz"
    sha256 "229afe2f6e1c9fabef64fc2bdf2a10e794ca6c4a0c00a687d53fbfaf7b8ee71d"
  end

  resource "requests-ntlm" do
    url "https:files.pythonhosted.orgpackages15745d4e1815107e9d78c44c3ad04740b00efd1189e5a9ec11e5275b60864e54requests_ntlm-1.3.0.tar.gz"
    sha256 "b29cc2462623dffdf9b88c43e180ccb735b4007228a542220e882c58ae56c668"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
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
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "scp" do
    url "https:files.pythonhosted.orgpackagesd61cd213e1c6651d0bd37636b21b1ba9b895f276e8057f882c9f944931e4f002scp-0.15.0.tar.gz"
    sha256 "f1b22e9932123ccf17eebf19e0953c6e9148f589f93d91b872941a696305c83f"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
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
    url "https:files.pythonhosted.orgpackages25ebb35901548315a66dd9e84c9dbb0e19532090051a78797586e8c2a56bf376transitions-0.9.1.tar.gz"
    sha256 "3542c37108e93e2ae5f215208ec5732c94a772937854a102cd7345b967fee61b"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages745be025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
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