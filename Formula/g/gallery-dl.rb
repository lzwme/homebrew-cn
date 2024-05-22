class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https:github.commikfgallery-dl"
  url "https:files.pythonhosted.orgpackages12309afa8353dca40bf1fd98f83deb36f52d12619b786ad028b8603da2819d0bgallery_dl-1.26.9.tar.gz"
  sha256 "3e06dfa69c890a9805ba90509e0f0c50f8a16c39a2b780bec569d2cc2272bb99"
  license "GPL-2.0-only"
  revision 2
  head "https:github.commikfgallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fd08ff6cfb154a766a827e733883187738374bd5b6ef37f4a631bfdbda58118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e4e6e89977e44fd9c720fc77ce84da6810853aa2cdba5f91a31befb170a6938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a4accf5748eda988288f94a32cad32311f10c5111b9f72cec2082d580424a87"
    sha256 cellar: :any_skip_relocation, sonoma:         "473042b55778df4ee4f51e0be909f29fc014293de74b22f8f397c63ff3dec94d"
    sha256 cellar: :any_skip_relocation, ventura:        "794053914a654d091ed52fcc4ef6a99e12f888e5567d1932698f742ee43a4111"
    sha256 cellar: :any_skip_relocation, monterey:       "409618bce358ccb2fb63d804c08f926cfe92f659f1766dd18868763368a690f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144388c3e1920ff7c453a6aa07c6f849f20392f0b88582e23fb6029839b0ea06"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagesd8c1f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    system "make" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec"sharemanman1gallery-dl.1"
    man5.install_symlink libexec"sharemanman5gallery-dl.conf.5"
    bash_completion.install libexec"sharebash-completioncompletionsgallery-dl"
    zsh_completion.install libexec"sharezshsite-functions_gallery-dl"
    fish_completion.install libexec"sharefishvendor_completions.dgallery-dl.fish"
  end

  test do
    system bin"gallery-dl", "https:imgur.comadyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath"gallery-dlimgurdyvohpFimgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end