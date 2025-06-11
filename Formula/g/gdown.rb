class Gdown < Formula
  include Language::Python::Virtualenv

  desc "Google Drive Public File Downloader when CurlWget Fails"
  homepage "https:github.comwkentarogdown"
  url "https:files.pythonhosted.orgpackages096a37e6b70c5bda3161e40265861e63b64a86bfc6ca6a8f1c35328a675c84fdgdown-5.2.0.tar.gz"
  sha256 "2145165062d85520a3cd98b356c9ed522c5e7984d408535409fd46f94defc787"
  license "MIT"
  revision 1
  head "https:github.comwkentarogdown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e130d64e7245977d80f9e901685495e2d9c1282d4454481b85ff74a722f7117"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gdown -V")
    system bin"gdown", "https:drive.google.comuc?id=0B9P1L--7Wd2vU3VUVlFnbTgtS2c"
    assert_path_exists "spam.txt"
  end
end