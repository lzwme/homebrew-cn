class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for CC++"
  homepage "https:conan.io"
  url "https:files.pythonhosted.orgpackages579a401e18c965945f8979bf861c8a146dce4edb4f46fa2e6c906d83f203a991conan-2.0.14.tar.gz"
  sha256 "3bbb4f4c4d749384af9ae5db26984b7f44949cafd340dcf6d2fd86d207731bb2"
  license "MIT"
  head "https:github.comconan-ioconan.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d33ddf24f6422b1f244dcfec6905fd2e57d2ac97955e5f4b8ce7adea7172a099"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f325bcbdd35f2fba1f16c95a8670425bc5bb8a63ccba273e375c026f83ba16ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daeb709dfffd9d137755e7b73a2ff300380e37d8e2953d1178db9c0b3cde5af7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7d252aecc3ab87b4f0b8ed51cdff1168ffed80d23bf1f0dc1bb46f9c2433b67"
    sha256 cellar: :any_skip_relocation, ventura:        "960304928593aaf1f1d3e8eea81b023cddd1cc398e281665c7b34f24626634e2"
    sha256 cellar: :any_skip_relocation, monterey:       "a25f7dc81aeaf37c54c99caefc3c14987c77dad619d0dec8fe3afa916456dc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fcc73402a9032e58a3a0ef5e60847569456d98d617152410996db6bff805925"
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
    url "https:files.pythonhosted.orgpackages4b89eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "fasteners" do
    url "https:files.pythonhosted.orgpackages5fd4e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
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