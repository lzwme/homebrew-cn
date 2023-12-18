class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https:github.comjjjakeinternetarchive"
  url "https:files.pythonhosted.orgpackages7a6ace5deecc9a65709e48367bf949874551fee5f4f595141b7fd0d4426b0d95internetarchive-3.5.0.tar.gz"
  sha256 "2a9625e1dcbe431e5b898402273a4345bf5cb46012599cbe92e664ffdc36e881"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b63ea2dc2e3833bcbc2cdff29707455af4a10d0a97ce20a099d161a587d32a0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a96eed814b3ac1b04f2af5bdfc1bee92317ed3b849482ff2197102777b23da07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50c37b13dbacb7d499299f983ddff6e54eb8339d5a2ee528ddf4880dd61aeb50"
    sha256 cellar: :any_skip_relocation, sonoma:         "58029b191bb4b4260680d624d52dba6eae9ae9afa7e925e437ba41189e0babbf"
    sha256 cellar: :any_skip_relocation, ventura:        "30bdb5f7cdb6fa269923fb4df46eb61c2b8efa49ee4a4d606bbef67a00175c94"
    sha256 cellar: :any_skip_relocation, monterey:       "acadb0ed0d4dbaa4914d66fd3f4b84bddf75b022bf8aaa5f70be70835edf20a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a5d702aab58e696f355d143d1df051cc43dd20b95d257ede56c0776036d87f"
  end

  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "contextlib2" do
    url "https:files.pythonhosted.orgpackagesc71337ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8fcontextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonpatch" do
    url "https:files.pythonhosted.orgpackages427818813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https:files.pythonhosted.orgpackages8f5e67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bcjsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackages4ee801e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec"binia"
  end

  test do
    metadata = JSON.parse shell_output("#{bin}ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end