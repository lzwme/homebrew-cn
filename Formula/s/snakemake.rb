class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https:snakemake.readthedocs.io"
  url "https:files.pythonhosted.orgpackagesd43a2ef43c366fa23a7c0a6776d2d874b663c3b5f68bef7969721f72df60405dsnakemake-9.3.3.tar.gz"
  sha256 "734fd7f25ca3caec415689f3f35f151044b65f2d1ca50d4ca1035ec6edaf7d68"
  license "MIT"
  head "https:github.comsnakemakesnakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08edc5855fceb28665a10fb57bb10eb4b2e2467925da0199c71628e55a8e8578"
    sha256 cellar: :any,                 arm64_sonoma:  "07c2d84db24139e33b7315e74ee3a5466ac65f9bdb1bac827ab2d6402924506d"
    sha256 cellar: :any,                 arm64_ventura: "611e60f1e01df512116c36d19fdb2877d8f01aee11197f3ef7207e3c0c155fe3"
    sha256 cellar: :any,                 sonoma:        "08f64c7e09d337d7f03b8e02467521c5007deae629456bcc159811593f36d1a0"
    sha256 cellar: :any,                 ventura:       "aa3ba12655d608a6c3c91ed745af03754abde50c2bbfb2fafd600a58af50bcc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb9bccfff11dff8deb7c8e2a189c4e9e4bab6f6442fad8842908738fa0fef17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f1dc3d646944d740a9183e2b90303212ad2c5379353cdeef05430c42b517c7"
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
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "conda-inject" do
    url "https:files.pythonhosted.orgpackagesb1a88dc86113c65c949cc72d651461d6e4c544b3302a85ed14a5298829e6a419conda_inject-1.3.2.tar.gz"
    sha256 "0b8cde8c47998c118d8ff285a04977a3abcf734caf579c520fca469df1cd0aac"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
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
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesbfce46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "jupyter-core" do
    url "https:files.pythonhosted.orgpackages0011b56381fa6c3f4cc5d2cf54a7dbf98ad9aa0b339ef7a601d6053538b079a7jupyter_core-5.7.2.tar.gz"
    sha256 "aa5f8d32bbf6b431ac830496da7392035d6f61b4f54872f15c4bd2a9c3f536d9"
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
    url "https:files.pythonhosted.orgpackagesb62d7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pulp" do
    url "https:files.pythonhosted.orgpackagesfb92bf4b947ec8aac629b835b588e70664c1d0150a8369f798b6c5adb32e39bapulp-3.1.1.tar.gz"
    sha256 "300a330e917c9ca9ac7fda6f5849bbf30d489c368117f197a3e3fd0bc1966d95"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "reretry" do
    url "https:files.pythonhosted.orgpackages401d25d562a62b7471616bccd7c15a7533062eb383927e68667bf331db990415reretry-0.11.8.tar.gz"
    sha256 "f2791fcebe512ea2f1d153a2874778523a8064860b591cd90afc21a8bed432e3"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0bb352b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
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
    url "https:files.pythonhosted.orgpackages09d4dd2694226160c126e3ce2a27222088bde3ef07cd554d31d63398cc48f810snakemake_interface_common-1.17.4.tar.gz"
    sha256 "c2142e1b93cbc18c2cf41d15968ba8688f60b077c8284e5de057cccfc215d4d3"
  end

  resource "snakemake-interface-executor-plugins" do
    url "https:files.pythonhosted.orgpackages619dca71ec355208cb3f4b2dfb590a09f5081b17e6272cdb904c97de5ee93996snakemake_interface_executor_plugins-9.3.5.tar.gz"
    sha256 "483b4c6b70f92170c4d87cfe213fad4ecab58abfeaee1ec428d3403026745265"
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
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackagesc3fce91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcefwrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "yte" do
    url "https:files.pythonhosted.orgpackages792de397aba1d413e6141ee52e495600d613d77e7d3d89270eda9c60818139bcyte-1.7.0.tar.gz"
    sha256 "d9cadcb597128490356a8260842fd71bf3145fa4ee633ecc4023f53a6b3f646d"
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