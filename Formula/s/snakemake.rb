class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https:snakemake.readthedocs.io"
  url "https:files.pythonhosted.orgpackagesacc1babf5581609dc42a51c4c000fa57ceaa4bdf889fded1aaf491bc80beade5snakemake-8.23.2.tar.gz"
  sha256 "bfda3c75114879f649b03d68d558d7e8edb4e0a17dae24e48434f1556ab7a993"
  license "MIT"
  head "https:github.comsnakemakesnakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d076e8d771d6bb9259de2ef25dee830c984bee2619ee2c96b3d22514f9bd895"
    sha256 cellar: :any,                 arm64_sonoma:  "153110296c0f1ed4ddbe5b4316f0751f7432ce5e4117d5bf93aa3692a870f555"
    sha256 cellar: :any,                 arm64_ventura: "3619682ffe5ced5e14630d1721c7e1aee14cc9034fb5fd57f7729cee27c6612b"
    sha256 cellar: :any,                 sonoma:        "9c4b8ade1aa9991083fe97f85259faa25d9e0a4845099ff8a67d81b1a6068e1a"
    sha256 cellar: :any,                 ventura:       "7b9de4c24b0f7eb4730d3bafb10334e47a5441167271ff0c80e349d9c963773a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07eff6294f95c3931af0a687bbe3c9bf132331501fbd4ff236982d31957c8672"
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
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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

  resource "datrie" do
    url "https:files.pythonhosted.orgpackages9dfedb74bd405d515f06657f11ad529878fd389576dca4812bea6f98d9b31574datrie-0.8.2.tar.gz"
    sha256 "525b08f638d5cf6115df6ccd818e5a01298cd230b2dac91c8ff2e6499d18765d"
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
    url "https:files.pythonhosted.orgpackages033f3ad5e7be13b4b8b55f4477141885ab2364f65d5f6ad5f7a9daffd634d066fastjsonschema-2.20.0.tar.gz"
    sha256 "3d48fc5300ee96f5d116f10fe6f28d938e6008f59a6a025c2649475b87f76a23"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
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
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "jupyter-core" do
    url "https:files.pythonhosted.orgpackages0011b56381fa6c3f4cc5d2cf54a7dbf98ad9aa0b339ef7a601d6053538b079a7jupyter_core-5.7.2.tar.gz"
    sha256 "aa5f8d32bbf6b431ac830496da7392035d6f61b4f54872f15c4bd2a9c3f536d9"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb4d238ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8fmarkupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "nbformat" do
    url "https:files.pythonhosted.orgpackages6dfd91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "plac" do
    url "https:files.pythonhosted.orgpackages9b791edb4c836c69306d0ecb0865f46d62ea7e28ef16b3f95bb394e4f2a46330plac-1.4.3.tar.gz"
    sha256 "d4cb3387b2113a28aebd509433d0264a4e5d9bb7c1a86db4fbd0a8f11af74eb3"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages26102a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "pulp" do
    url "https:files.pythonhosted.orgpackagesbbd57cb148b56f3603be3663498db3a63054d7d519eab32ef9c39f93faf6b7a9pulp-2.9.0.tar.gz"
    sha256 "2e30e6c0ef2c0edac185220e3e53faca62eb786a9bd68465208f05bc63e850f3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
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
    url "https:files.pythonhosted.orgpackages5564b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29arpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "smart-open" do
    url "https:files.pythonhosted.orgpackagesa3d81481294b2d110b805c0f5d23ef34158b7d5d4283633c0d34c69ea89bb76bsmart_open-7.0.5.tar.gz"
    sha256 "d3672003b1dbc85e2013e4983b88eb9a5ccfd389b0d4e5015f39a9ee5620ec18"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "snakemake-interface-common" do
    url "https:files.pythonhosted.orgpackages09d4dd2694226160c126e3ce2a27222088bde3ef07cd554d31d63398cc48f810snakemake_interface_common-1.17.4.tar.gz"
    sha256 "c2142e1b93cbc18c2cf41d15968ba8688f60b077c8284e5de057cccfc215d4d3"
  end

  resource "snakemake-interface-executor-plugins" do
    url "https:files.pythonhosted.orgpackages6f77f3e7a7abff8f15bd50f168eef1e3153167a681bfd51a454a3adb0918cb8dsnakemake_interface_executor_plugins-9.3.2.tar.gz"
    sha256 "19c50dc82989ff25d10386cfb3c99da9d2dc980d95ecd30bbb431374dcd390b3"
  end

  resource "snakemake-interface-report-plugins" do
    url "https:files.pythonhosted.orgpackages5eaeee9a6c9475e380bb55020dc161ab08698fe85da9e866477bfb333b15a0edsnakemake_interface_report_plugins-1.1.0.tar.gz"
    sha256 "b1ee444b2fca51225cf8a102f8e56633791d01433cd00cf07a1d9713a12313a5"
  end

  resource "snakemake-interface-storage-plugins" do
    url "https:files.pythonhosted.orgpackagesc77df5d9662f97121cc42415197bacccb7a1cc893524da1138c2fc19ef835881snakemake_interface_storage_plugins-3.3.0.tar.gz"
    sha256 "203d8f794dfb37d568ad01a6c375fa8beac36df8e488c0f9b9f75984769c362a"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yte" do
    url "https:files.pythonhosted.orgpackages584b3f89f96417e4e39c3f3e3f4a17d6233e81dc1e5cd5b5ed0a2498faedf690yte-1.5.4.tar.gz"
    sha256 "d2d77e53eafca74f58234fcd3fea28cc0a719e4f3784911511e35e86594bc880"
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
    assert_predicate testpath"test.out", :exist?
    assert_match "Building DAG of jobs...", test_output
  end
end