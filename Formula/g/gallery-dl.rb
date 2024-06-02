class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https:github.commikfgallery-dl"
  url "https:files.pythonhosted.orgpackages3a5a2648a7a0d090170be8b0009ffa3edc738c0c93cfdcaaa0c82982b01b61f4gallery_dl-1.27.0.tar.gz"
  sha256 "ccc8a61e3697830392b7c1db49e738a34cb77bd5dfead145888e0acecacff39d"
  license "GPL-2.0-only"
  head "https:github.commikfgallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d29e6b50d311ee581a7030856622ce701a7e80d3eab7a2c785abf8bf0573dab5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d29e6b50d311ee581a7030856622ce701a7e80d3eab7a2c785abf8bf0573dab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d29e6b50d311ee581a7030856622ce701a7e80d3eab7a2c785abf8bf0573dab5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d29e6b50d311ee581a7030856622ce701a7e80d3eab7a2c785abf8bf0573dab5"
    sha256 cellar: :any_skip_relocation, ventura:        "d29e6b50d311ee581a7030856622ce701a7e80d3eab7a2c785abf8bf0573dab5"
    sha256 cellar: :any_skip_relocation, monterey:       "d29e6b50d311ee581a7030856622ce701a7e80d3eab7a2c785abf8bf0573dab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84099c72889c0239f472d783375c5742b26b726995a4a3405cf1d78088101b6c"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    system "make", "man", "completion" if build.head?
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