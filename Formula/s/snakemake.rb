class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/72/0a/5416785decae3cbf0a67be8092c18be5c7d73ca9c8a4d6525575c892958f/snakemake-9.17.1.tar.gz"
  sha256 "a7aa8c404150328307430ceff65e7ea86425fc03eaa93e5fbf6c629a573ef8cf"
  license "MIT"
  head "https://github.com/snakemake/snakemake.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3a1b0d19fb894ed136971b24e69f68e03e7ea0ebb1dc2c1fb73f91b441c5769f"
    sha256 cellar: :any,                 arm64_sequoia: "c52052fae505967fafa3e918a23e98cfb5c43511d7c662e612744c6d68fa654f"
    sha256 cellar: :any,                 arm64_sonoma:  "0a926af850f1f89610fb84ec8aacd645867d4dffdb82c46e505aca1689df90d1"
    sha256 cellar: :any,                 sonoma:        "14b7872cd3319954d294cad0f161c1adb093dd7e6bf3832d4743d393524f1019"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42f55d5942d4f7311d9aa721456a5b087cddf5da4243e635bb735abcc9fd7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2620e6efbd15519446539eb34d43087c3910203d46faa5215157ec183b092250"
  end

  depends_on "rust" => :build # for appdirs
  depends_on "cbc"
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi pydantic rpds-py]

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argparse-dataclass" do
    url "https://files.pythonhosted.org/packages/1a/ff/a2e4e328075ddef2ac3c9431eb12247e4ba707a70324894f1e6b4f43c286/argparse_dataclass-2.0.0.tar.gz"
    sha256 "09ab641c914a2f12882337b9c3e5086196dbf2ee6bf0ef67895c74002cc9297f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/1d/35/02daf95b9cd686320bb622eb148792655c9412dbb9b67abb5694e5910a24/charset_normalizer-3.4.5.tar.gz"
    sha256 "95adae7b6c42a6c5b5b559b1a99149f090a57128155daeea91732c8d970d8644"
  end

  resource "conda-inject" do
    url "https://files.pythonhosted.org/packages/b1/a8/8dc86113c65c949cc72d651461d6e4c544b3302a85ed14a5298829e6a419/conda_inject-1.3.2.tar.gz"
    sha256 "0b8cde8c47998c118d8ff285a04977a3abcf734caf579c520fca469df1cd0aac"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "connection-pool" do
    url "https://files.pythonhosted.org/packages/bd/df/c9b4e25dce00f6349fd28aadba7b6c3f7431cc8bd4308a158fbe57b6a22e/connection_pool-0.0.3.tar.gz"
    sha256 "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/b6/03bb70946330e88ffec97aefd3ea75ba575cb2e762061e0e62a213befee8/docutils-0.22.4.tar.gz"
    sha256 "4db53b1fde9abecbb74d91230d32ab626d94f6badfc575d6db9194a49df29968"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/b5/ce/e1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9/dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/df/b5/59d16470a1f0dfe8c793f9ef56fd3826093fc52b3bd96d6b9d6c26c7e27b/gitpython-3.1.46.tar.gz"
    sha256 "400124c7d0ef4ea03f7310ac2fbf7151e09ff97f2a3288d64a440c584a29c37f"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "immutables" do
    url "https://files.pythonhosted.org/packages/69/41/0ccaa6ef9943c0609ec5aa663a3b3e681c1712c1007147b84590cec706a0/immutables-0.21.tar.gz"
    sha256 "b55ffaf0449790242feb4c56ab799ea7af92801a0a43f9e2f4f8af2ab24dfc4a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/02/49/9d1284d0dc65e2c757b74c6687b6d319b02f822ad039e5c512df9194d9dd/jupyter_core-5.9.1.tar.gz"
    sha256 "4d09aaff303b9566c3ce657f580bd089ff5c91f5f89cf7d8846c3cdf465b5508"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6d/fd/91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3/nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pulp" do
    url "https://files.pythonhosted.org/packages/16/1c/d880b739b841a8aa81143091c9bdda5e72e226a660aa13178cb312d4b27f/pulp-3.3.0.tar.gz"
    sha256 "7eb99b9ce7beeb8bbb7ea9d1c919f02f003ab7867e0d1e322f2f2c26dd31c8ba"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "reretry" do
    url "https://files.pythonhosted.org/packages/40/1d/25d562a62b7471616bccd7c15a7533062eb383927e68667bf331db990415/reretry-0.11.8.tar.gz"
    sha256 "f2791fcebe512ea2f1d153a2874778523a8064860b591cd90afc21a8bed432e3"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/e8/be/a66598b305763861a9ab15ff0f2fbc44e47b1ce7a776797337a4eef37c66/smart_open-7.5.1.tar.gz"
    sha256 "3f08e16827c4733699e6b2cc40328a3568f900cb12ad9a3ad233ba6c872d9fe7"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "snakemake-interface-common" do
    url "https://files.pythonhosted.org/packages/89/c3/592f832f6e5d2d31f749392e48e8401b7625dec668d3d365d8d28f2b6c30/snakemake_interface_common-1.23.0.tar.gz"
    sha256 "6ed14531a461417659364a0dd0acc51b786af4e26fc15cc5e00ff3d9fcaffacc"
  end

  resource "snakemake-interface-executor-plugins" do
    url "https://files.pythonhosted.org/packages/54/50/de06b284c45a8e94fb8e4a12d5235065e78b49b8f84329dc10fe39f4b7dd/snakemake_interface_executor_plugins-9.4.0.tar.gz"
    sha256 "9d4138897beacbaadaedad94b63f948eaeb604b7fc78f9cf65ac57f090f2c066"
  end

  resource "snakemake-interface-logger-plugins" do
    url "https://files.pythonhosted.org/packages/c0/92/2fe4fa879a5d4408cad6db5330cd4ebd352e47529cb0fdfdf8ebf73f2920/snakemake_interface_logger_plugins-2.0.0.tar.gz"
    sha256 "0e8ff2af4c55ca140d6ea1c1540e733a4b3944abae48fe0eaf6a707e5797cd17"
  end

  resource "snakemake-interface-report-plugins" do
    url "https://files.pythonhosted.org/packages/18/d6/6160ed98de665d6871dd356597dbf726688cc786e88668359ca37b7d9f54/snakemake_interface_report_plugins-1.3.0.tar.gz"
    sha256 "fc9495298bec4e69721ab8afe6d6d88a86966fda2eeb003db56b9a88b86d5934"
  end

  resource "snakemake-interface-scheduler-plugins" do
    url "https://files.pythonhosted.org/packages/88/d9/d480807d2cfc2d132bc760d877d45ec8fbe620a24200ec4d2697c4a26031/snakemake_interface_scheduler_plugins-2.0.2.tar.gz"
    sha256 "2797e8fa9019d983132c2b403f14d6fcd3c5ad4c8d8a66b984b4740a71cacc46"
  end

  resource "snakemake-interface-storage-plugins" do
    url "https://files.pythonhosted.org/packages/89/95/35d6421faa328b4bc4df1179b1b4219720b967f34dd2e88671f9d35759f7/snakemake_interface_storage_plugins-4.3.3.tar.gz"
    sha256 "fd6afe2f0bed6cb02fd4b34a54c3bd9bbc9a606ff27476b8a55edbc3b54a0905"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/1f/73/b4a9737255583b5fa858e0bb8e116eb94b88c910164ed2ed719147bde3de/sqlalchemy-2.0.48.tar.gz"
    sha256 "5ca74f37f3369b45e1f6b7b06afb182af1fd5dde009e4ffd831830d98cbe5fe7"
  end

  resource "sqlmodel" do
    url "https://files.pythonhosted.org/packages/fb/26/1d2faa0fd5a765267f49751de533adac6b9ff9366c7c6e7692df4f32230f/sqlmodel-0.0.37.tar.gz"
    sha256 "d2c19327175794faf50b1ee31cc966764f55b1dedefc046450bc5741a3d68352"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "throttler" do
    url "https://files.pythonhosted.org/packages/ce/3f/47baf510c31e0e52ac0d80d9071e5e166ca069167fee4a6c13841f9d5f5f/throttler-1.2.3.tar.gz"
    sha256 "d2f5b0b499d62f1fc984dcac8043450b606549b0097753a9c8a707f7427c27e1"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2e/64/925f213fdcbb9baeb1530449ac71a4d57fc361c053d06bf78d0c5c7cd80c/wrapt-2.1.2.tar.gz"
    sha256 "3996a67eecc2c68fd47b4e3c564405a5777367adfd9b8abb58387b63ee83b21e"
  end

  resource "yte" do
    url "https://files.pythonhosted.org/packages/44/f5/7e44620e6e077bfe624b9a17c329b8e0d0159e176e1f1a93c2790428ab2c/yte-1.9.4.tar.gz"
    sha256 "86a47e6d722cec9419a7ac88be57d0d6c4ce28f02860393b71a66f2c674069f6"
  end

  def install
    venv = virtualenv_install_with_resources
    rm_r(venv.site_packages/"pulp/solverdir/cbc")
  end

  test do
    (testpath/"Snakefile").write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakemake --cores 1 -s #{testpath}/Snakefile 2>&1")
    assert_path_exists testpath/"test.out"
    assert_match "Building DAG of jobs...", test_output
  end
end