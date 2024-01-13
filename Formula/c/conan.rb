class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for CC++"
  homepage "https:conan.io"
  url "https:files.pythonhosted.orgpackages41786a976e70794cb051c3f52d2b8b7eae77594dec2d0119ea66069d397ffafaconan-2.0.17.tar.gz"
  sha256 "56251a16297e5893e21641c33063cbeaec9b0c28fed2ea2242ddc0e4a6aa350d"
  license "MIT"
  revision 1
  head "https:github.comconan-ioconan.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70ee5076efd3d9648a57acd5200329e382b4cb072790c705e31e73546fc68245"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3dff9911c16945eacf4e9a52c59c83b61a1a8251fded0c36f8477344b298bb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06faa66f7cecddfcb19ad3e41609a69af6000453afb7545c83d3a835ae2e7bb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2513ceb1b4ce856b7c4abc9010a4a1b9485737590943b897a27ace39f02bd8fb"
    sha256 cellar: :any_skip_relocation, ventura:        "b7b95b7fb2427025f8a5a1dbe78f0c5f39b7f23617951c0eb8a7e2ea584dca6e"
    sha256 cellar: :any_skip_relocation, monterey:       "9948a75ec36f82480e34ae8dc8c4ba73bd12e73165d9fdd7af25473c68714bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab59427fcd428dfd0d8d147909ce8c43239d5cf1227f7111d5999e235bce9f9"
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :test
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-markupsafe"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fasteners" do
    url "https:files.pythonhosted.orgpackages5fd4e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "patch-ng" do
    url "https:files.pythonhosted.orgpackagesc1b2ad3cd464101435fdf642d20e0e5e782b4edaef1affdf2adfc5c75660225bpatch-ng-1.17.4.tar.gz"
    sha256 "627abc5bd723c8b481e96849b9734b10065426224d4d22cd44137004ac0d4ace"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"conan", "profile", "detect"
    system bin"conan", "install", "--requires=zlib1.2.11",
                                   "--build=missing",
                                   "--lockfile-out=conan.lock"
    lockfile = JSON.parse(File.read("conan.lock", mode: "r"))
    refute_predicate lockfile["requires"].select { |req| req.start_with?("zlib1.2.11") }, :empty?
  end
end