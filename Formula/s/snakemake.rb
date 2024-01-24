class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https:snakemake.readthedocs.io"
  url "https:files.pythonhosted.orgpackages7e90190812dbe691eef658f140dac34d2d281e9d611da5bbf56ba494a95b4ef5snakemake-8.2.4.tar.gz"
  sha256 "c707139e21b6624c79a5de7e737c4a484133c703e04f96c74c2554071c503d85"
  license "MIT"
  head "https:github.comsnakemakesnakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ffc36853cf58eb658de7ef538a5dfe9ac9b7f9872869e0cb41c23e99e7cd87ba"
    sha256 cellar: :any,                 arm64_ventura:  "5f283bdbf58cdf178f04b633da47ccd6a942feaefa9b2433954bcc2024621750"
    sha256 cellar: :any,                 arm64_monterey: "ee6206219ef4cd725876dae27804de55e03e2b84325fec17493bbf006c162c13"
    sha256 cellar: :any,                 sonoma:         "1d6a6f2aed04f566f89ca8e719f59296af25b75816142ed46acc4ae0f5fe0cd9"
    sha256 cellar: :any,                 ventura:        "6ede3a17500061b942329fd68c3e038d8f7780c33e11bf0d6917181cc366ae7a"
    sha256 cellar: :any,                 monterey:       "9be3ba66c9d4fbbd41c3680771b4ca807bd2b3ae61112ce3b02f30be2cd63d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbff643acb63895252277801d900025ea1e20c69ac147d2123da8b16419d9859"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cbc"
  depends_on "docutils"
  depends_on "python-certifi"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argparse-dataclass" do
    url "https:files.pythonhosted.orgpackages1affa2e4e328075ddef2ac3c9431eb12247e4ba707a70324894f1e6b4f43c286argparse_dataclass-2.0.0.tar.gz"
    sha256 "09ab641c914a2f12882337b9c3e5086196dbf2ee6bf0ef67895c74002cc9297f"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "conda-inject" do
    url "https:files.pythonhosted.orgpackagesf86cfc8bf18a8245cd96303d5fbfab0762ed35e3b3ecddeefdc181aa7ce6ead5conda_inject-1.3.1.tar.gz"
    sha256 "9e8d902230261beba74083aae12c2c5a395e29b408469fefadc8aaf51ee441e5"
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

  resource "dpath" do
    url "https:files.pythonhosted.orgpackages0a81044f03129b6006fc594654bb26c22a9417346037261c767ac6e0773ca1dddpath-2.1.6.tar.gz"
    sha256 "f1e07c72e8605c6a9e80b64bc8f42714de08a789c7de417e49c3f87a19692e47"
  end

  resource "fastjsonschema" do
    url "https:files.pythonhosted.orgpackagesba7fcedf77ace50aa60c566deaca9066750f06e1fcf6ad24f254d255bb976dd6fastjsonschema-2.19.1.tar.gz"
    sha256 "e3126a94bdc4623d3de4485f8d468a12f02a67921315ddc87836d6e456dc789d"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagese5c26e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3fGitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

  resource "humanfriendly" do
    url "https:files.pythonhosted.orgpackagescc3f2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "immutables" do
    url "https:files.pythonhosted.orgpackages7d6327f038a28ff2110bc04908a047817fd316d5a16ae06d0d3707732dee8013immutables-0.20.tar.gz"
    sha256 "1d2f83e6a6a8455466cd97b9a90e2b4f7864648616dfa6b19d18f49badac3876"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages4dc53f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9bejsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "jupyter-core" do
    url "https:files.pythonhosted.orgpackagesc3de53a5c189e358dae95d4176c6075127822c9b00193e8d7b1a77003aab253djupyter_core-5.7.1.tar.gz"
    sha256 "de61a9d7fc71240f688b2fb5ab659fbb56979458dc66a71decd098e03c79e218"
  end

  resource "nbformat" do
    url "https:files.pythonhosted.orgpackages54d831dceef56952da6ea2c43405a83c9759a22a86cb530197988cfa8599b178nbformat-5.9.2.tar.gz"
    sha256 "5f98b5ba1997dff175e77e0c17d5c10a96eaed2cbd1de3533d1fc35d5e111192"
  end

  resource "plac" do
    url "https:files.pythonhosted.orgpackagesf2159c8b756afb87cd99f9d10ecc7b022276abf3f1ac46554bf864614885a635plac-1.4.2.tar.gz"
    sha256 "b0d04d9bc4875625df45982bc900e9d9826861c221850dbfda096eab82fe3330"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "pulp" do
    url "https:files.pythonhosted.orgpackages2ce0683a36567b0a396961192dc9ec477ba1f88be56d968ca26688bd6e02f23bPuLP-2.8.0.tar.gz"
    sha256 "4903bf96110bbab8ed2c68533f90565ebb76aa367d9e4df38e51bf727927c125"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages81ce910573eca7b1a1c6358b0dc0774ce1eeb81f4c98d4ee371f1c85f22040a1referencing-0.32.1.tar.gz"
    sha256 "3c57da0513e9563eb7e203ebe9bb3a1b509b042016433bd1e45a2853466c3dd3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "reretry" do
    url "https:files.pythonhosted.orgpackages401d25d562a62b7471616bccd7c15a7533062eb383927e68667bf331db990415reretry-0.11.8.tar.gz"
    sha256 "f2791fcebe512ea2f1d153a2874778523a8064860b591cd90afc21a8bed432e3"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackagesb70ae3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161ferpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
  end

  resource "smart-open" do
    url "https:files.pythonhosted.orgpackagesac69bf2e8a00fbf9bf9f27734c4f3f2030fb422c4d8b1594bb9fc763561a4ec2smart_open-6.4.0.tar.gz"
    sha256 "be3c92c246fbe80ebce8fbacb180494a481a77fcdcb7c1aadb2ea5b9c2bee8b9"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "snakemake-interface-common" do
    url "https:files.pythonhosted.orgpackages33afbb9675b5b72f42d02d9c05b4967d9200f609726bb1ae4be3eca4f8bb6fecsnakemake_interface_common-1.15.2.tar.gz"
    sha256 "f2a4908a5ec5d6e657723f90221da3c136e70a1c5897b4e1d65a703bc08e8d7a"
  end

  resource "snakemake-interface-executor-plugins" do
    url "https:files.pythonhosted.orgpackages32118032e5f21e5e33822185d5001a5bb1b6e3743795304149d18da435ae4284snakemake_interface_executor_plugins-8.2.0.tar.gz"
    sha256 "4c74e3e1751bab6b266baf8688e854b8b4c5c5e10f5e34c581f42d69af4ff13b"
  end

  resource "snakemake-interface-storage-plugins" do
    url "https:files.pythonhosted.orgpackages1088eda765d65b9d7ce1e976347aed065428063bb5c4f41b1d8bcae33915abd1snakemake_interface_storage_plugins-3.0.0.tar.gz"
    sha256 "f20d85ee7e86a1e2ffa3f72e2385dd5abb17fa7b58a26cba8ba59096872fe169"
  end

  resource "stopit" do
    url "https:files.pythonhosted.orgpackages3558e8bb0b0fb05baf07bbac1450c447d753da65f9701f551dca79823ce15d50stopit-1.1.2.tar.gz"
    sha256 "f7f39c583fd92027bd9d06127b259aee7a5b7945c1f1fa56263811e1e766996d"
  end

  resource "throttler" do
    url "https:files.pythonhosted.orgpackagesb422638451122136d5280bc477c8075ea448b9ebdfbd319f0f120edaecea2038throttler-1.2.2.tar.gz"
    sha256 "d54db406d98e1b54d18a9ba2b31ab9f093ac64a0a59d730c1cf7bb1cdfc94a58"
  end

  resource "toposort" do
    url "https:files.pythonhosted.orgpackages69198e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678btoposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackagesf1b919206da568095bbf2e57f9f7f7cb6b3b2af2af2670f8c83c23a53d6c00cdtraitlets-5.14.1.tar.gz"
    sha256 "8585105b371a04b8316a43d5ce29c098575c2e477850b62b848b964f1444527e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yte" do
    url "https:files.pythonhosted.orgpackages584b3f89f96417e4e39c3f3e3f4a17d6233e81dc1e5cd5b5ed0a2498faedf690yte-1.5.4.tar.gz"
    sha256 "d2d77e53eafca74f58234fcd3fea28cc0a719e4f3784911511e35e86594bc880"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources

    # cleanup `pulpsolverdircbc`
    site_packages_path = Language::Python.site_packages(python3)
    pulp_solverdir_path = libexecsite_packages_path"pulpsolverdircbc"
    pulp_solverdir_path.rmtree
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