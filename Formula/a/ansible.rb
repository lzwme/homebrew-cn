class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https:www.ansible.com"
  url "https:files.pythonhosted.orgpackages5c54dc559b305948e9c234f79ef00f7aed52d7c127c8616c0c2f3f336103ccddansible-11.1.0.tar.gz"
  sha256 "d01b425990d960d2a33fc378e1b73dbca1c0e28bc22f4056ab6b3c8e9ae74fba"
  license "GPL-3.0-or-later"
  head "https:github.comansibleansible.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e8c14b327926551ce23eb5e8da53934eda4b7a7386002a4c9ea77d2062ddeaf"
    sha256 cellar: :any,                 arm64_sonoma:  "f72bdfb73c29aa15ca7d14810bf927c6086c62f525d644c45c1fbd2f39b947cf"
    sha256 cellar: :any,                 arm64_ventura: "1fa5a0dd31e741bbd906312037b37bc117a4f4a2be954b392b2d5e7be7c6f052"
    sha256 cellar: :any,                 sonoma:        "9cad1f4cb9648b83738b09de1ec3e67d7c44d16fea056259df4f22278ad21dba"
    sha256 cellar: :any,                 ventura:       "b6bcf47e59b0a1ef04d6c3b877ad23835018bb429ded95b873404be7f890ff18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d7733cb583d7f3bd0028924ab30c8b774dc822b26a559607a950d7520c71c89"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libssh"
  depends_on "libyaml"
  depends_on "python@3.13"

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
    url "https:files.pythonhosted.orgpackages424615836f1f48e2682bd5d04f7b3e2cb27e17626bec3cd7a4f2a7b0ccefbbd2ansible_core-2.18.1.tar.gz"
    sha256 "14cac1f92bbdae881cb0616eddeb17925e8cb507e486087975e724533d9de74f"
  end

  resource "ansible-pylibssh" do
    url "https:files.pythonhosted.orgpackages935038298568fbd517dcb7b08c06f4fbfc0481ab9eae1e4b01920495dacf672aansible-pylibssh-1.2.2.tar.gz"
    sha256 "753e570dcdceb6ab8e362e91cc0d5993beebc93d287b88178db55509f6423ab5"
  end

  resource "apache-libcloud" do
    url "https:files.pythonhosted.orgpackages1b451a239d9789c75899df8ff53a6b198c1657328f3b333f1711194643d53868apache-libcloud-3.8.0.tar.gz"
    sha256 "75bf4c0b123bc225e24ca95fca1c35be30b19e6bb85feea781404d43c4276c91"
  end

  resource "autopage" do
    url "https:files.pythonhosted.orgpackages9f9e559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages568cdd696962612e4cd83c40a9e6b3db77bfe65a830f4b9af44098708584686cbcrypt-4.2.1.tar.gz"
    sha256 "6765386e3ab87f569b276988742039baab087b2cdb01e809d74e74503c2faafe"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesd1b3146636e2e20421b94e85ee1deffa59448d713664df794f83686ae162ea0bboto3-1.35.75.tar.gz"
    sha256 "a30b7ef273fbcb41390d6495f3b3e95c6fae496366447238095b00825cb5a52a"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages1d7607c65844c2c87a0ffc279e40d0eb668732fd54081adb3f7887933258ee25botocore-1.35.75.tar.gz"
    sha256 "7c7d272d9794d07f0c40caa110a266e910103559340b5a5d252857928e920a4a"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "cliff" do
    url "https:files.pythonhosted.orgpackages6244e9073c882c9765074a1043f5004f31fd97c5c6571836e59987fa28781805cliff-4.8.0.tar.gz"
    sha256 "23eff502e603cf0aa841eaea6662a42cd3064169162b3e596b20226400e34dfd"
  end

  resource "cmd2" do
    url "https:files.pythonhosted.orgpackages2a8a42bfec2be9da0fe22519404329da302c1ca4e0d2a01a5cdf8b8785a91926cmd2-2.5.7.tar.gz"
    sha256 "0219e2bb75075fa16deffb88edf86efdd2a87439d1fa7b94fdea4b929a3dc914"
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
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages919b4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83cedocker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "dogpile-cache" do
    url "https:files.pythonhosted.orgpackages813b83ce66995ce658ad63b86f7ca83943c466133108f20edc7056d4e0f41347dogpile.cache-1.3.3.tar.gz"
    sha256 "f84b8ed0b0fb297d151055447fa8dcaf7bae566d4dbdefecdcc1f37662ab588b"
  end

  resource "durationpy" do
    url "https:files.pythonhosted.orgpackages31e9f49c4e7fccb77fa5c43c2480e09a857a78b41e7331a75e128ed5df45c56bdurationpy-0.9.tar.gz"
    sha256 "fd3feb0a69a0057d582ef643c355c40d2fa1c942191f914d12203b1a01ac722a"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages6a714c5387d8a3e46e3526a8190ae396659484377a73b33030614dd3b28e7dedgoogle_auth-2.36.0.tar.gz"
    sha256 "545e9618f2df0bcbb7dcbc45a546485b1212624716975a1ea5ae8149ce769ab1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackages522805d6d7a15e231b91f2e3133f29ab235f7798393d30a39a8611a12a90cf55junos-eznc-2.7.2.tar.gz"
    sha256 "7c7e6f8e9bb9d0d034ffaeb592e400dd114f03db44c3bb608c951e88483c825d"
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
    url "https:files.pythonhosted.orgpackages81904057a98c59f5634c7404c09b849e030c528ed65924eea4cd4e01e43634ffkeystoneauth1-5.9.1.tar.gz"
    sha256 "fb0c66d842d5b964752264fff20b3b4ab73610d66d9b8d20d0dcf796ba09dc43"
  end

  resource "kubernetes" do
    url "https:files.pythonhosted.orgpackages7ebdffcd3104155b467347cd9b3a64eb24182e459579845196b3a200569c8912kubernetes-31.0.0.tar.gz"
    sha256 "28945de906c8c259c1ebe62703b56a03b714049372196f854105afe4e6d014c0"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagescbd07555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4fmsgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
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
    url "https:files.pythonhosted.orgpackages8d4834dfcabb7cd60f006166f7a7162bc12399391f7d4863071d02880faad2afntc_templates-7.4.0.tar.gz"
    sha256 "898948948983237a0cc739b55d19890148badc0f6521f85245bca9e7d953f4e2"
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
    url "https:files.pythonhosted.orgpackages327b42529e0014cf5c3e1a4f4c07ed43c1df357d57f5f61ca15cbdbfdd229654openstacksdk-4.1.0.tar.gz"
    sha256 "ccac9b158e3d36b959a3bdce71bd4f883d7758fef6856841c855ff2b22c941ea"
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
    url "https:files.pythonhosted.orgpackagesdcdb0a907d200719f755f00579f116526abea404a8a7961d8cd4019f1e1235edosc-lib-3.2.0.tar.gz"
    sha256 "5f706be145daf0e58068e3763ec56bde2f43ed229a738628e4c0fb1defb4ed9e"
  end

  resource "oslo-config" do
    url "https:files.pythonhosted.orgpackages2ee92cac91d42e8fb86b17ef8f350b523f70282fbc9f3a0785884e455b132e50oslo.config-9.7.0.tar.gz"
    sha256 "b371ebf3f9a63e92b81d5c72b84d2f96f40553532699c68e1c5cd8ca9eca088b"
  end

  resource "oslo-context" do
    url "https:files.pythonhosted.orgpackages99f31a7fa94ca9d7807f193c83ea403f8526e19301f0cecbf20bd6f35c29fcfboslo.context-5.7.0.tar.gz"
    sha256 "398c460b9cf7cb397ede7962223e4b88078fb2fbc53665a47a34e1b28890f4ce"
  end

  resource "oslo-i18n" do
    url "https:files.pythonhosted.orgpackagescaa59ecdc0b2620efae576a7688283d34a2c273989e6e850ee9be8116296b7d5oslo.i18n-6.5.0.tar.gz"
    sha256 "9393bcae92eadc5f771132d1c6ab239b19896ff6d885e3afc21a9faa4de924d3"
  end

  resource "oslo-log" do
    url "https:files.pythonhosted.orgpackages2b62e06b206d07a5761fbe40b1538c0163ae58b29955606b682ed3611e64ab98oslo.log-6.2.0.tar.gz"
    sha256 "2b151d9c3f2b2ecc12c06d0fb7dbf2e9047afdaec3644827fa1e10b354369563"
  end

  resource "oslo-serialization" do
    url "https:files.pythonhosted.orgpackages1e4e54d2fc3c2a9620a9a7572bb89ca7bc2b02a1e0e511004f27eced4c613759oslo.serialization-5.6.0.tar.gz"
    sha256 "4c7d4e12da853cc4f04b9123041134e886e8c9ff57ab57c1962d3ad4a87b7f7c"
  end

  resource "oslo-utils" do
    url "https:files.pythonhosted.orgpackages11c0c78c13a54bd920baf2e756e9b8f92be320b311e83c3998b69f7b84da29f9oslo.utils-8.0.0.tar.gz"
    sha256 "906fcf1c86f671f224c1925b2a8d375a0539143fb6158b13e202a79dd8e6c694"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages1b0fc00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609bparamiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
  end

  resource "passlib" do
    url "https:files.pythonhosted.orgpackagesb6069da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackagesb23580cf8f6a4f34017a7fe28242dc45161a1baa55c41563c354d8147e8358b2pbr-6.1.0.tar.gz"
    sha256 "788183e382e3d1d7707db08978239965e8b9e4e5ed42669bf4758186734d5f24"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages3b8ade4dc1a6098621781c266b3fb3964009af1e9023527180cb8a3b0dd9d09eprettytable-3.12.0.tar.gz"
    sha256 "f04b3e1ba35747ac86e96ec33e3bb9748ce08e254dc2a1c6253945901beec804"
  end

  resource "proxmoxer" do
    url "https:files.pythonhosted.orgpackagese399eb6129acd6552178b5fb20d101e43f1c78695140f1c3c2769f5dcb37a56dproxmoxer-2.1.0.tar.gz"
    sha256 "d92993782e74ed8a76ff355dc050f58aa039fa697f9349a68e643552bd0fa62e"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages26102a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages1d676afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pynetbox" do
    url "https:files.pythonhosted.orgpackages1af9e6c524e5ddc4c2788ab2f5ee1ab2d9afad49cad9c7cd3a372cf5b8433ed3pynetbox-7.4.1.tar.gz"
    sha256 "3f82b5964ca77a608aef6cc2fc48a3961f7667fbbdbb60646655373e3dae00c3"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8cd5e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
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
    url "https:files.pythonhosted.orgpackages6bf853f1fc851dab776a183ffc9f29ebde244fbb467f5237f3ea809519fc4b2epyspnego-0.11.2.tar.gz"
    sha256 "994388d308fb06e4498365ce78d222bf4f3570b6df4ec95738431f61510c971b"
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
    url "https:files.pythonhosted.orgpackagesea5e2d6700c6e36c288ec7e6d24ad49ef400311e8d2b2d926b16906f12c1cb26python-keystoneclient-5.5.0.tar.gz"
    sha256 "c2f5934f95576936c98e45bf599ad48bcb0ac451593e5f8344ebf52cb0f411f5"
  end

  resource "python-neutronclient" do
    url "https:files.pythonhosted.orgpackages6eb2b2cb8b08085e419907a28932ca55a2d54b71bd41aedb10f9faf03410e218python-neutronclient-11.3.1.tar.gz"
    sha256 "53cd9923f43a3b0772a40e3561f74655adc8038f90261ab3de05b6211d12edcb"
  end

  resource "python-string-utils" do
    url "https:files.pythonhosted.orgpackages10918c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pywinrm" do
    url "https:files.pythonhosted.orgpackages5a2fd835c342c4b11e28beaccef74982e7669986c84bf19654c39f53c8b8243cpywinrm-0.5.0.tar.gz"
    sha256 "5428eb1e494af7954546cd4ff15c9ef1a30a75e05b25a39fd606cef22201e9f1"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
    url "https:files.pythonhosted.orgpackagesc00a1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "scp" do
    url "https:files.pythonhosted.orgpackagesd61cd213e1c6651d0bd37636b21b1ba9b895f276e8057f882c9f944931e4f002scp-0.15.0.tar.gz"
    sha256 "f1b22e9932123ccf17eebf19e0953c6e9148f589f93d91b872941a696305c83f"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "shade" do
    url "https:files.pythonhosted.orgpackagesb0a6a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackages4ae94eedccff8332cc40cc60ddd3b28d4c3e255ee7e9c65679fa4533ab98f598stevedore-5.4.0.tar.gz"
    sha256 "79e92235ecb828fe952b6b8b0c6c87863248631922c8e8e0fa5b17b232c4514d"
  end

  resource "textfsm" do
    url "https:files.pythonhosted.orgpackagesb8bfc9147d29c5a3ff4c1c876e16ea02f6d4e4f35ba1bcbb2ac80a254924f0aatextfsm-1.1.3.tar.gz"
    sha256 "577ef278a9237f5341ae9b682947cefa4a2c1b24dbe486f94f2c95addc6504b5"
  end

  resource "transitions" do
    url "https:files.pythonhosted.orgpackages4a824dfbb3cf62501cb3e8d026cbeb2d5cdeaf5bfe916ea50d3a9435faa2b0e1transitions-0.9.2.tar.gz"
    sha256 "2f8490dbdbd419366cef1516032ab06d07ccb5839ef54905e842a472692d4204"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackagese134943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
    url "https:files.pythonhosted.orgpackages24a1fc03dca9b0432725c2e8cdbf91a349d2194cf03d8523c124faebe581de09wrapt-1.17.0.tar.gz"
    sha256 "16187aa2317c731170a88ef35e8937ae0f533c402872c1ee5e6d079fcf320801"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages500551dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958fxmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  resource "yamlordereddictloader" do
    url "https:files.pythonhosted.orgpackages2378f853b0db6d8f3ea0ae4c648e4504ba376d024c139ba1292a256ce6180dd0yamlordereddictloader-0.4.2.tar.gz"
    sha256 "36af2f6210fcff5da4fc4c12e1d815f973dceb41044e795e1f06115d634bca13"
  end

  resource "zabbix-api" do
    url "https:files.pythonhosted.orgpackages4ace893d6ab7e978d0c00d9154c0cf385016b862438da069302e7ceac0f6c429zabbix-api-0.5.6.tar.gz"
    sha256 "627ad26769b6831130239182afcb195f64fbf494626bc9eb4b2ac8170de5b775"
  end

  def install
    venv = virtualenv_install_with_resources without: "ansible-core"
    venv.pip_install_and_link resource("ansible-core")
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath"tmp"
    (testpath"playbook.yml").write <<~YAML
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    YAML
    python3 = "python#{Language::Python.major_minor_version libexec"binpython"}"
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