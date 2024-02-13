class Cycode < Formula
  include Language::Python::Virtualenv

  desc "Boost security in your dev lifecycle via SAST, SCA, Secrets & IaC scanning"
  homepage "https:github.comcycodehqcycode-cli"
  url "https:files.pythonhosted.orgpackagesd88fd7f1f83acbdc7e97db9da204bf2b231f3863e80d4182267b5c744f842161cycode-1.9.0.tar.gz"
  sha256 "77b28d8a70998a149b93365653e350b1c1a32175ff13bb1b03faf7f8c1ea3a69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23090e35ab3d8fecb6a4cf8a50b20a92b38b97bbe8889b8482abbe6c36afdc49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "860fe0e7eb471b5f29cdccadadce0a25f026f15a8f2fe6194f40d6513506e030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a15e0375757a220eae916640eab3d8fcb890bddbd3d16a20fe3425fc941f3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff343841da4d7b898be583248d972513d96e99718433bec732dc8805dd7b4056"
    sha256 cellar: :any_skip_relocation, ventura:        "82163101459645612661b244769fe6ea90936e6715c2af4ed073bd4011c45572"
    sha256 cellar: :any_skip_relocation, monterey:       "435433f7a55a50b0bdf47e250e32ba1cb81a206d13ebdee122968c8b6b397b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bedaf2438802260fe4b8d1e51d88380a9a227036883782f305494a70cd159598"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages7fc0c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "binaryornot" do
    url "https:files.pythonhosted.orgpackagesa7fe7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49bbinaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagese5c26e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3fGitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackages0381763717b3448e5d3a3906f27ab2ffedc9a495e8077946f54b8033967d29fdmarshmallow-3.20.2.tar.gz"
    sha256 "4c1daff273513dc5eb24b219a8035559dc573c8f322558ef85f5438ddd1236dd"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagesa02abd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "texttable" do
    url "https:files.pythonhosted.orgpackages1cdc0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"cycode", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "Error: ignore by type is missing", shell_output("#{bin}cycode ignore 2>&1", 1)
    assert_match "Error: Cycode client id needed.", shell_output("#{bin}cycode scan path 2>&1", 1)
    output = shell_output("#{bin}cycode scan -t test 2>&1", 2)
    assert_match "Error: Invalid value for '--scan-type'  '-t'", output
    assert_equal "Cycode authentication failed", shell_output("#{bin}cycode auth check").strip
    assert_match version.to_s, shell_output("#{bin}cycode version")
  end
end