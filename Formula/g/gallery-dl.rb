class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https:github.commikfgallery-dl"
  url "https:files.pythonhosted.orgpackages4e1069926f779acea5f0a606ec60902ff24f946d3f819e748bec7f2470553a65gallery_dl-1.27.4.tar.gz"
  sha256 "dbccb9b14f689cf1c8aa54c8633210f89d8a12526871bbb029037f139d09188f"
  license "GPL-2.0-only"
  head "https:github.commikfgallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08a353f1335707808194b07441371777bbb28e7b7e8adbb742be4a31cb18bedf"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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