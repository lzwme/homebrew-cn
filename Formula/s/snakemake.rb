class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https:snakemake.readthedocs.io"
  url "https:files.pythonhosted.orgpackagescf44d903047585b627872b81a3276906f73194bb597ceb6db54709be7a2c25b6snakemake-9.6.2.tar.gz"
  sha256 "906ab7b8c8af8b6b3d9c783fcc30d3c91a4dd6865f9270b7b62a858884d727b8"
  license "MIT"
  head "https:github.comsnakemakesnakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7cbddb73f2b8e710d4c912bb615beb78b383dfd6f1ed026ed9e41eb7672e1a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "c3c3508117138d2729e4cbf7cb277c34f857ab711148634c8e017a97fe42cbc0"
    sha256 cellar: :any,                 arm64_ventura: "6a3430ca32ec32c92a0eedf13a2a4fa83792bf316c68605730027589ddb8d3a2"
    sha256 cellar: :any,                 sonoma:        "43b8edff7de007c5eb57cea8737520867f2a49624da712f4d78b731b321f0bb7"
    sha256 cellar: :any,                 ventura:       "76a9d3a6109d170d78203f42b2c5543bd2257b8be1afd82fc6c929f08a71df56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d12a4a8b2c1f580d1fbbab5f21d2dbf7fc0b73cff93fbc639fa9a3cc66f7c273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c1d1c1d25934294eac1d1ec15781edab1e3d0343cc0adcdfff8da342780a42b"
  end

  depends_on "rust" => :build
  depends_on "cbc"
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argparse-dataclass" do
    url "https:files.pythonhosted.orgpackages1affa2e4e328075ddef2ac3c9431eb12247e4ba707a70324894f1e6b4f43c286argparse_dataclass-2.0.0.tar.gz"
    sha256 "09ab641c914a2f12882337b9c3e5086196dbf2ee6bf0ef67895c74002cc9297f"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "conda-inject" do
    url "https:files.pythonhosted.orgpackagesb1a88dc86113c65c949cc72d651461d6e4c544b3302a85ed14a5298829e6a419conda_inject-1.3.2.tar.gz"
    sha256 "0b8cde8c47998c118d8ff285a04977a3abcf734caf579c520fca469df1cd0aac"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages854d6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5dconfigargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "connection-pool" do
    url "https:files.pythonhosted.orgpackagesbddfc9b4e25dce00f6349fd28aadba7b6c3f7431cc8bd4308a158fbe57b6a22econnection_pool-0.0.3.tar.gz"
    sha256 "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "dpath" do
    url "https:files.pythonhosted.orgpackagesb5cee1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackages8b504b769ce1ac4071a1ef6d86b1a3fb56cdc3a37615e8c5519e1af96cdac366fastjsonschema-2.21.1.tar.gz"
    sha256 "794d4f0a58f848961ba16af7b9c85a3e88cd360df008c59aac6fc5ae9323b5d4"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "humanfriendly" do
    url "https:files.pythonhosted.orgpackagescc3f2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "immutables" do
    url "https:files.pythonhosted.orgpackages69410ccaa6ef9943c0609ec5aa663a3b3e681c1712c1007147b84590cec706a0immutables-0.21.tar.gz"
    sha256 "b55ffaf0449790242feb4c56ab799ea7af92801a0a43f9e2f4f8af2ab24dfc4a"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesbfd31cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "jupyter-core" do
    url "https:files.pythonhosted.orgpackages991b72906d554acfeb588332eaaa6f61577705e9ec752ddb486f302dafa292d9jupyter_core-5.8.1.tar.gz"
    sha256 "0a5f9706f70e64786b75acba995988915ebd4601c8a52e534a40b51c95f59941"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "nbformat" do
    url "https:files.pythonhosted.orgpackages6dfd91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "plac" do
    url "https:files.pythonhosted.orgpackages230926ef2d614cabdcc52a7f383d0dc7967bf46be3c9700898c594e37b710c3dplac-1.4.5.tar.gz"
    sha256 "5f05bf85235c017fcd76c73c8101d4ff8e96beb3dc58b9a37de49cac7de82d14"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pulp" do
    url "https:files.pythonhosted.orgpackages2fcdcb1308632ad5b092ebbfe64d0cd0b9906caec6e52bff88f54ddd3d434694pulp-3.2.1.tar.gz"
    sha256 "fc6c02c47c06342c586b175924add753cad7638ff6149b3b43e87ac6709ac469"
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

  resource "reretry" do
    url "https:files.pythonhosted.orgpackages401d25d562a62b7471616bccd7c15a7533062eb383927e68667bf331db990415reretry-0.11.8.tar.gz"
    sha256 "f2791fcebe512ea2f1d153a2874778523a8064860b591cd90afc21a8bed432e3"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages8ca660184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "smart-open" do
    url "https:files.pythonhosted.orgpackages21301f41c3d3b8cec82024b4b277bfd4e5b18b765ae7279eb9871fa25c503778smart_open-7.1.0.tar.gz"
    sha256 "a4f09f84f0f6d3637c6543aca7b5487438877a21360e7368ccf1f704789752ba"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "snakemake-interface-common" do
    url "https:files.pythonhosted.orgpackagesf6853fd50b731dacc19d9bd2facb92612fe73bdb983eecadfd7cc7ddf570160dsnakemake_interface_common-1.19.4.tar.gz"
    sha256 "99cfbbd01def8f75e67eb0fd244ab7ee3abb3b3f12597f6d14d0c8b92e407340"
  end

  resource "snakemake-interface-executor-plugins" do
    url "https:files.pythonhosted.orgpackagesc5029b3c4963076e8cdd27c4160d3ad60a74ae6d941fbc5c6eec007bf7ac1adesnakemake_interface_executor_plugins-9.3.7.tar.gz"
    sha256 "5df352e0260b7125b3c05bb959be6e46f4a2abd046c14ea9c2ab84415c05c391"
  end

  resource "snakemake-interface-logger-plugins" do
    url "https:files.pythonhosted.orgpackagesb23096e98e0d3feedcaf40820f7604cc86dfb9a0174408e7f70a7fd876a9b8c8snakemake_interface_logger_plugins-1.2.3.tar.gz"
    sha256 "9228cc01f2cc0b35e9144c02d10f71cc9874296272896aeb86f9fac7db5e2c69"
  end

  resource "snakemake-interface-report-plugins" do
    url "https:files.pythonhosted.orgpackages5eaeee9a6c9475e380bb55020dc161ab08698fe85da9e866477bfb333b15a0edsnakemake_interface_report_plugins-1.1.0.tar.gz"
    sha256 "b1ee444b2fca51225cf8a102f8e56633791d01433cd00cf07a1d9713a12313a5"
  end

  resource "snakemake-interface-storage-plugins" do
    url "https:files.pythonhosted.orgpackages258229b9212ece305f2a8db47c1b8fabb14174aa7fdde8005a4912c011c3bb54snakemake_interface_storage_plugins-4.2.1.tar.gz"
    sha256 "41f23c1940942d45fe6afa6578b50a7181b2d4d32013421ef2fc1ea0e4bbe137"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "throttler" do
    url "https:files.pythonhosted.orgpackagesb422638451122136d5280bc477c8075ea448b9ebdfbd319f0f120edaecea2038throttler-1.2.2.tar.gz"
    sha256 "d54db406d98e1b54d18a9ba2b31ab9f093ac64a0a59d730c1cf7bb1cdfc94a58"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackageseb7972064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackagesc3fce91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcefwrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "yte" do
    url "https:files.pythonhosted.orgpackagesf319a56a000125ade3e9b4d25122f1725c8fdaf24cc907eb296b80f7991d81f9yte-1.8.1.tar.gz"
    sha256 "6eefbdceae56e156ba9881ecb63f3c9217cfe5d5cc6f85fdb061c266a8eff112"
  end

  def install
    venv = virtualenv_install_with_resources
    rm_r(venv.site_packages"pulpsolverdircbc")
  end

  test do
    (testpath"Snakefile").write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}snakemake --cores 1 -s #{testpath}Snakefile 2>&1")
    assert_path_exists testpath"test.out"
    assert_match "Building DAG of jobs...", test_output
  end
end