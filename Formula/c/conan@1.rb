class ConanAT1 < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for CC++"
  homepage "https:conan.io"
  url "https:files.pythonhosted.orgpackagescea06e0014057ff382428cbee2254d9e29c6ce09baa8e0bc3dd440e388aee7fdconan-1.64.1.tar.gz"
  sha256 "969c5e2f504963ef9211605939a519588d63fd218ada5bb227272a8c653f2ec4"
  license "MIT"
  revision 2

  livecheck do
    url "https:github.comconan-ioconan.git"
    regex(^v?(1(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46a09a591af34d614beba442b7bf2a19beb3c47d3873cea92ea8a5c0aee68c91"
    sha256 cellar: :any,                 arm64_ventura:  "6449a7e49384f273be40a46f10dec66eba3d4f2f6447819351b7c3b617b46554"
    sha256 cellar: :any,                 arm64_monterey: "47398762381c54cf4ff95c3249bdd27e5ff67da0573976ae85d96d97e4883ab8"
    sha256 cellar: :any,                 sonoma:         "04154d9fc13436267459acb071723465816cb1bff208b7f5571fb1aafbd277c4"
    sha256 cellar: :any,                 ventura:        "9e034a322c082d05ca84b668f7ab9595c0a259266d02a6810a083a39de840be2"
    sha256 cellar: :any,                 monterey:       "27cb6178a1f1899908c1119681a225030b3b0e13465688e8b7afb2847943b2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "601fbf60ca3c450f3c272406d8d3dcb3a68d5337f0e3a87e65561f0537017621"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "cmake" => :test
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesfd041c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "node-semver" do
    url "https:files.pythonhosted.orgpackagesf14e1d9a619dcfd9f42d0e874a5b47efa0923e84829886e6a47b45328a1f32f1node-semver-0.6.1.tar.gz"
    sha256 "4016f7c1071b0493f18db69ea02d3763e98a633606d7c7beca811e53b5ac66b7"
  end

  resource "patch-ng" do
    url "https:files.pythonhosted.orgpackagesc1b2ad3cd464101435fdf642d20e0e5e782b4edaef1affdf2adfc5c75660225bpatch-ng-1.17.4.tar.gz"
    sha256 "627abc5bd723c8b481e96849b9734b10065426224d4d22cd44137004ac0d4ace"
  end

  resource "pluginbase" do
    url "https:files.pythonhosted.orgpackagesf307753451e80d2b0bf3bceec1162e8d23638ac3cb18d1c38ad340c586e90b42pluginbase-1.0.1.tar.gz"
    sha256 "ff6c33a98fce232e9c73841d787a643de574937069f0d18147028d70d7dee287"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesc89365e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1burllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"conan", "search", "zlib", "--remote", "conancenter"

    system bin"conan", "install", "zlib1.2.11@", "--build"
    assert_predicate testpath".conandatazlib1.2.11", :exist?
  end
end