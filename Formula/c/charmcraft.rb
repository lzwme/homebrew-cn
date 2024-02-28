class Charmcraft < Formula
  include Language::Python::Virtualenv

  desc "Tool to build charms and publish them on Charmhub"
  homepage "https:charmhub.io"
  url "https:files.pythonhosted.orgpackages883088063d83fd81f1334a1c720d56ddd37adc4137350b87079438957b90bff3charmcraft-2.5.2.tar.gz"
  sha256 "874a95dc0d9a4d688625bf04eaa5a14921715425167412d5e0d89c158636e02e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "dc3b326a754fa51c79f3b99644dc1575a1fc66489f4284e4f3df72e764f1e73b"
    sha256 cellar: :any,                 arm64_ventura:  "bdc423e0c781fa0cdddcf718d1da3521ce6c40d706cd0871e6ee551dd29db0f0"
    sha256 cellar: :any,                 arm64_monterey: "2038c9899385991de84356a03f44bc108384b5b0e1a9811813fdef38ec0391a8"
    sha256 cellar: :any,                 sonoma:         "bfb9126481401c621e8c998d46f9a934f57f7a377aacbbc8dc256cf6c69672df"
    sha256 cellar: :any,                 ventura:        "2f00bf91b23b748c5d8e0e507537d4a40b693a05973fba88a4888532ea05d189"
    sha256 cellar: :any,                 monterey:       "00bfc409d95ce97bfa087151f9094f5e38959023de388c28593a479ac2bf4110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6653675f552f2dec55caba28a01708e927f1fb5943c41b1d0fdebbabf36992a0"
  end

  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  on_linux do
    resource "jeepney" do
      url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "secretstorage" do
      url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "craft-application" do
    url "https:files.pythonhosted.orgpackagesd3a43a0055042d6e2cfd48e0e961f09aad023fb7c3001c53b05049a0cb0a90a8craft-application-1.2.1.tar.gz"
    sha256 "20e24f9496e051fb5bb17a7b6ea78b0d4d3cd5e07a02160d44d9146187765495"
  end

  resource "craft-cli" do
    url "https:files.pythonhosted.orgpackages01eadb04e74eadf461d0326a43878844322abf4c572a3f9e3d090eb0f521303dcraft-cli-2.5.0.tar.gz"
    sha256 "f565847ef40c3295c066e9ff560b7fbeb532f7744640eec13474ee1c522a52d9"
  end

  resource "craft-parts" do
    url "https:files.pythonhosted.orgpackagesf5de7d7543d834a7b48a45c85f9e3ac4a240319ac116ebd739d500a1bc52221dcraft-parts-1.26.1.tar.gz"
    sha256 "b830c6a89d726e53da628235ea2274acbec9b67b1dac331f3144139a20436470"
  end

  resource "craft-providers" do
    url "https:files.pythonhosted.orgpackages5d08002ca96723a68a7269c1dbd578623d79eff88943518295df0538c31fde49craft-providers-1.20.1.tar.gz"
    sha256 "139e1a0f71814b9517c501253001382412d927be639556ff39a6e4abb85f06cf"
  end

  resource "craft-store" do
    url "https:files.pythonhosted.orgpackagesca793f2fef793e78fe347964c012e988c739f68fbdf0d8a3c3f91e9e153b3cedcraft-store-2.6.0.tar.gz"
    sha256 "fb1ae34ccb6c525267bbaef1d91069b6c077924a706bf80ccc6652720497f609"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages76217a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75chumanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages90b4206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesa87477bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03affjsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages69cd889c6569a7e5e9524bc1e423fd2badd967c4a5dcd670c04c2eff92a9d397keyring-24.3.0.tar.gz"
    sha256 "e730ecffd309658a08ee82535a3b5ec4b4c8669a9be11efb66249d8e0aeb9a25"
  end

  resource "macaroonbakery" do
    url "https:files.pythonhosted.orgpackages4bae59f5ab870640bd43673b708e5f24aed592dc2673cc72caa49b0053b4af37macaroonbakery-1.3.4.tar.gz"
    sha256 "41ca993a23e4f8ef2fe7723b5cd4a30c759735f1d5021e990770c8a0e0f33970"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages6d7c59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbfMarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "overrides" do
    url "https:files.pythonhosted.orgpackages4d2730c865a1e62f1913a0730e667e94459ca038392b6f44d69ef7a585690337overrides-7.4.0.tar.gz"
    sha256 "9502a3cca51f4fac40b5feca985b6703a5c1f6ad815588a7ca9e285b9dca6757"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages555be3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bcprotobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesb96c7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages5e0b95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46depycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages51cd721eb771f3f09f60de0807e240c3acf44c38828d0ced869fe8df7e79801bpydantic-1.10.13.tar.gz"
    sha256 "32c8b48dcd3b2ac4e78b0ba4af3a2c2eb6048cb75202f0ea7b34feb740efc340"
  end

  resource "pydantic-yaml" do
    url "https:files.pythonhosted.orgpackages9ee730713a0fae04001f8886b0219cad667b0fbf56149f4ea3ee5a84e8e0c9e7pydantic_yaml-0.11.2.tar.gz"
    sha256 "19c8f3c9a97041b0a3d8fc06ca5143ff71c0846c45b39fde719cfbc98be7a00c"
  end

  resource "pymacaroons" do
    url "https:files.pythonhosted.orgpackages37b452ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923epymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyrfc3339" do
    url "https:files.pythonhosted.orgpackages005275ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyxdg" do
    url "https:files.pythonhosted.orgpackagesb0257998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages81ce910573eca7b1a1c6358b0dc0774ce1eeb81f4c98d4ee371f1c85f22040a1referencing-0.32.1.tar.gz"
    sha256 "3c57da0513e9563eb7e203ebe9bb3a1b509b042016433bd1e45a2853466c3dd3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket" do
    url "https:files.pythonhosted.orgpackagesc3ea0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354ebrequests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackagesc26394a1e9406b34888bdf8506e91d654f1cd84365a5edafa5f8ff0c97d4d9e1rpds_py-0.16.2.tar.gz"
    sha256 "781ef8bfc091b19960fc0142a23aedadafa826bc32b433fdfe6fd7f964d7ef44"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "snap-helpers" do
    url "https:files.pythonhosted.orgpackages502a221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackages7a53afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4atabulate-0.8.10.tar.gz"
    sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  end

  resource "types-deprecated" do
    url "https:files.pythonhosted.orgpackages016e91782182aff68ead125aa145b18f5b203884c1be7de67c689e638f85f519types-Deprecated-1.2.9.20240106.tar.gz"
    sha256 "afeb819e9a03d0a5795f18c88fe6207c48ed13c639e93281bd9d9b7bb6d34310"
  end

  resource "types-pyyaml" do
    url "https:files.pythonhosted.orgpackagesaf48b3bbe63a129a80911b60f57929c5b243af909bc1c9590917434bca61a4a3types-PyYAML-6.0.12.12.tar.gz"
    sha256 "334373d392fde0fdf95af5c3f1661885fa10c52167b14593eb856289e1855062"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Workaround https:github.comcanonicalcharmcraftissues1472
    inreplace "setup.py", "from tools.version import determine_version", ""
    inreplace "setup.py", "version=determine_version(),", "version='#{version}',"

    virtualenv_install_with_resources
  end

  test do
    system bin"charmcraft", "version"
    system bin"charmcraft", "help"
    system bin"charmcraft", "init", "--author", "Foo Bar", "-p", testpath"charm"
    assert_predicate testpath"charmcharmcraft.yaml", :exist?
  end
end