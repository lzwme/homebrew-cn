class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/5d/30/a214551b710258ee6c878d9b77bcc43d300a6dacecb6e6662220c623e147/python_openstackclient-8.1.0.tar.gz"
  sha256 "9b9c42b3f6bc4b4b480a6254fc560acb019787831e094396dbf9ac9ae571ae4b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77ca980936cfd1bd790348e691691b2db95e7e5a03172895f6e3c79f2613bfca"
    sha256 cellar: :any,                 arm64_sonoma:  "70eaba865529e667546feb9335a37a28c9d726dea0d423fd9594fb09d0225087"
    sha256 cellar: :any,                 arm64_ventura: "2d968e996776df02fd4d8931b9b204a8025ce29b9501d6950cf35195b1da03ed"
    sha256 cellar: :any,                 sonoma:        "f5129caced79082c49d287821c1ce025c42bddc5877e65a6aae0f8aeb8302c53"
    sha256 cellar: :any,                 ventura:       "9c8310bc8c3f75e21ab78b354b6149b1f4261c8a0607a7e8f06e6e519f1c8800"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fadc2d7216a2af18b8ae575befd90b940802022aadc139b6930d8fc539b3453a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a70cd83c3fcd47c02cd78d466b31e462c53c358ea7547f11eb5830956f84935"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyinotify" do
    on_linux do
      url "https://files.pythonhosted.org/packages/e3/c0/fd5b18dde17c1249658521f69598f3252f11d9d7a980c5be8619970646e1/pyinotify-0.9.6.tar.gz"
      sha256 "9c998a5d7606ca835065cdabc013ae6c66eb9ea76a00a1e3bc6e0cfe2b4f71f4"
    end
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/af/9f/c29775d39263b2c9054dc608e0d604db50ccc4a21be5fcd862cf41e1c033/cliff-4.10.0.tar.gz"
    sha256 "8c1f5b682741a03b0c4607c82e8af41d4e9c2859024646562f86cdeb2959a86d"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/f7/2a/018fe937e25e1db0cafeb358c117644a58cdba24f5bbee69c003faf0b454/cmd2-2.5.11.tar.gz"
    sha256 "30a0d385021fbe4a4116672845e5695bbe56eb682f9096066776394f954a7429"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e8/07/2257f13f9cd77e71f62076d220b7b59e1f11a70b90eb1e3ef8bdf0f14b34/dogpile_cache-1.4.0.tar.gz"
    sha256 "b00a9e2f409cf9bf48c2e7a3e3e68dac5fa75913acbf1a62f827c812d35f3d09"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
  end

  resource "jsonpath-rw-ext" do
    url "https://files.pythonhosted.org/packages/d5/f0/5d865b2543be45e3ab7a8c2ae8dfa5c3e56cfdd48f19d4455eb02f370386/jsonpath-rw-ext-1.2.2.tar.gz"
    sha256 "a9e44e803b6d87d135b09d1e5af0db4d4cf97ba62711a80aa51c8c721980a994"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "keystoneauth-websso" do
    url "https://files.pythonhosted.org/packages/11/5d/9425fc595cda8fb1975536a0f512d9a84c153386e57d8339ee0cf554c286/keystoneauth_websso-0.2.2.tar.gz"
    sha256 "de521a141319331a619ab2133dbb69f44dddceb92649d50a755a2257ac7127d6"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/d3/b1/21e3b5091920d22a93c382ecc8aa30a129aeb69e7e5976b09c276c2259a4/keystoneauth1-5.11.0.tar.gz"
    sha256 "9af6a165fa0747ed739ffc34b115ea0d7cfc5630ee12948af94f03ed0f9c8934"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/df/91/6c93b6a95e6a99ef929a99d019fbf5b5f7fd3368389a0b1ec7ce0a23565b/multipart-1.2.1.tar.gz"
    sha256 "829b909b67bc1ad1c6d4488fcdc6391c2847842b08323addf5200db88dbe9480"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/b8/72/0b7fe12a18f871dc57119651dba1a9c9976b8adcdfbad95b2e7224b06849/openstacksdk-4.5.0.tar.gz"
    sha256 "ab7a1240207a6969ba09ceee8f16653805730677b4497a806cd956733651fe68"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/58/be/ba2e4d71dd57653c8fefe8577ade06bf5f87826e835b3c7d5bb513225227/os-client-config-2.1.0.tar.gz"
    sha256 "abc38a351f8c006d34f7ee5f3f648de5e3ecf6455cc5d76cfd889d291cdf3f4e"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/58/3f/09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ec/os-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/a4/b1/ea4cb7eb0ab0702e08606f6072efafa8b6a35ecea520570bee9e44b54b31/osc_lib-4.0.2.tar.gz"
    sha256 "403f9d4cc1b13d934a3483b43afaf50886447a224fec74ada2b6c7087ad3d77d"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/e4/fb/5a692bbb4ce3fd59233dae986fec7ac53aca2a0053cf6218e452169071d8/osc_placement-4.6.0.tar.gz"
    sha256 "36ae070edbf76af42c1f0eccd7f6153a782040dbc910fbcd2ba7eeb02efd3b8d"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/69/be/da0a7c7785791ffae3a3365a8e9b88e5ee18837e564068c5ebc824beeb60/oslo_config-9.8.0.tar.gz"
    sha256 "eea8009504abee672137c58bdabdaba185f496b93c85add246e2cdcebe9d08aa"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/2a/6c/e1e7db0505ff70881336fb6865846885d1ff24fa7fd8e5cdd91016c35f07/oslo_context-6.0.0.tar.gz"
    sha256 "151e8228982d3885ed3fed288e8cddb26f894fb40cb8132129fa9e5b3e0ef0bd"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/cc/94/8ab2746a3251e805be8f7fd5243df44fe6289269ce9f7105bdbe418be90d/oslo_i18n-6.5.1.tar.gz"
    sha256 "ea856a70c5af7c76efb6590994231289deabe23be8477159d37901cef33b109d"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/72/e9/ed065144ab6dec839fe7bafebfa803b775eb2149db33878ca5ff613f6b11/oslo_log-7.1.0.tar.gz"
    sha256 "9a2b3c18be6f59152dfe25f34deabe71343db7fb8248a633967fb6a04707629d"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/a7/44/e7f2aaef66d7a02c74ce425f2bad8c4aaf11f39bb02fea98eeb7452a0910/oslo_serialization-5.7.0.tar.gz"
    sha256 "bdc4d3dd97b80639b3505e46d9aa439fc95028814177f30b91743e81366c3be7"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/9e/45/f381d0308a7679975ec0e8409ce133136ea96c1ed6a314eb31dcd700c7d8/oslo_utils-9.0.0.tar.gz"
    sha256 "d45a1b90ea1496589562d38fe843fda7fa247f9a7e61784885991d20fb663a43"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/01/d2/510cc0d218e753ba62a1bc1434651db3cd797a9716a0a66cc714cb4f0935/pbr-6.1.1.tar.gz"
    sha256 "93ea72ce6989eb2eed99d0f75721474f69ad88128afdef5ac377eb797c4bf76b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-barbicanclient" do
    url "https://files.pythonhosted.org/packages/8b/43/6fe98492ea213d3e9d10bd666668790bea70f73b4f2eb17a10c26a030ceb/python_barbicanclient-7.1.0.tar.gz"
    sha256 "1394b72a7a2c46378d78a7f3a3c8fbec5fe7f8598ae5ead47522afd8ffdb1696"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/ed/25/a2bf747f91f86e25f56115499da2654b7cab849c816c0774128066da2a3e/python_cinderclient-9.7.0.tar.gz"
    sha256 "18c4501e549677984d85b0b10fd074efbd265e30add2a796d28176055a8d7dcf"
  end

  resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/3c/cb/f67c65313297d8a3d93975012a2ab2364740b153493e54598f87bc1705a2/python_cloudkittyclient-5.3.1.tar.gz"
    sha256 "3528e4fe2d7ad52304dbd5d61e0f65f8590a33714e92994e270f520ede4826af"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/31/03/96a90b0a83c8e033a8d8d679e457acad18439f5de4a8a1b4a826ff02c412/python_designateclient-6.3.0.tar.gz"
    sha256 "9aabf25e5ff69b15fb6209f9851c507d9499e63c6926245672ff0e495986e778"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/9d/55/996a756318b17f162665cbc9f7e6219d6dc56875684693f07a60c02d7148/python_glanceclient-4.8.0.tar.gz"
    sha256 "f85b6fc81f27b34da1c87484b3097659db0529abd1c67595d2f0fe7cb159036c"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/f8/5f/9452cd84b77afa5db345d4db6de0a95ffc630c132cfb75573eda1f3ef425/python_heatclient-4.2.0.tar.gz"
    sha256 "728099d777f9964e5c679a85c2b849acf107e7942a9b36e1251e1fce1ce24d22"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/a1/2f/870939aa711fd337717de29ccba61e2c4462054473adbdf7ee28ad6afa2c/python_ironicclient-5.11.0.tar.gz"
    sha256 "9fe75be4c9718b6d759a3c14f0b593baf091583917ea43a47f564cd7a2f7305b"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/91/d9/e6b430abdd77caccfc0f47005f7ff2125d143b16bd6f9aaa46ceaac75b90/python_keystoneclient-5.6.0.tar.gz"
    sha256 "721de2aec7710076389c674ee27b6712e97d86c7e0ff487b0b4409c8fcee10e7"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/71/d5/16f96df3637d21e2c70657726270cd535001fbc233aa0fc3dc10e2337d0e/python_magnumclient-4.8.1.tar.gz"
    sha256 "6cd7d6f4ca508603f773344a4eb4e0d1968727171c726d12ee86d67635a7e3b5"
  end

  resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/f8/cc/7579afae20b6a7c77879fc6ace6295bf1943b6688ea35198c570bea4d97b/python_manilaclient-5.5.0.tar.gz"
    sha256 "c0f615674f9af60f883f7977787f603165df7b95465337a6eea58439667ebe5a"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/f4/e7/90ffb6e62715db2856d2b1e245c147abffbd0812c444caa51ccaa210cd99/python_mistralclient-5.4.0.tar.gz"
    sha256 "38e34060e89cf2bef4d750f131f61f86a45738d345d0d3918061c76e3f04d968"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/4d/eb/1f7ad4655f0241bff363ef9c75ec27198b55da0317c2f4e59dbea63d203a/python_neutronclient-11.5.0.tar.gz"
    sha256 "a1390c324e71164827e4ac77fd51d626c37019f2416b21514a762e2fc050b574"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/32/16/5b225b7bf7bae9144a5539b6491d7510178a9728483b5f98f8f43fcb5e37/python_octaviaclient-3.11.0.tar.gz"
    sha256 "233078d0b227f225bbb0ee9e07c3609e915cfef0617d9bf81cb317a60a5d3f55"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/57/a7/a30bf9fd517d7cc75fb111540c9962c166b9e9539d2ba2afab14a6aa1aa3/python_swiftclient-4.8.0.tar.gz"
    sha256 "44162cab469368cafdc25e0c8c4e95a2b9db1a44456a48ce080fe2ca9a4b3863"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/8c/a6/60184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921/rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/28/3f/13cacea96900bbd31bb05c6b74135f85d15564fc583802be56976c940470/stevedore-5.4.1.tar.gz"
    sha256 "3135b5ae50fe12816ef291baff420acb727fcd356106e3e9cbfa9e5985cd6f4b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/de/cf/ba9ac96d09b797c377e2c12c0eb6b19565f3b2a2efb55932d319e319b622/warlock-2.0.1.tar.gz"
    sha256 "99abbf9525b2a77f2cde896d3a9f18a5b4590db063db65e08207694d2e0137fc"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "resource provider list", # osc-placement
      "stack list", # python-heatclient
      "loadbalancer list", # python-octaviaclient
      "rating summary get", # python-cloudkittyclient
      "zone list", # python-designateclient
      "secret list", # python-barbicanclient
      "share list", # python-manliaclient
      "workflow list", # python-mistralclient
      "coe cluster list", # python-magnumclient
      "baremetal node list", # python-ironicclient
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end