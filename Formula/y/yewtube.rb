class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/yewtube"
  url "https://ghfast.top/https://github.com/mps-youtube/yewtube/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "012c1a8a185dd4ef81074631bca91e327ac4e634b36301a50ffbcd67838b847f"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/mps-youtube/yewtube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "feae9e2422eb561a4e97a40b5d127d445dae1cdd7727cd4dd5abacc38d762152"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "mplayer"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/16/ce/8a777047513153587e5434fd752e89334ac33e379aa3497db860eeb60377/anyio-4.12.0.tar.gz"
    sha256 "73c693b567b0c55130c104d0b43a9baf3aa6a31fc6110116509f27bf75e21ec0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pylast" do
    url "https://files.pythonhosted.org/packages/e5/63/18c2c08bbbf30bf331f965f842016d8426b3a4c26033e76be9f953c62848/pylast-7.0.0.tar.gz"
    sha256 "05803f66d50e33521788f01eb30a9d4e3fbffbb4d81420826a2e3e9ca598a370"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  resource "youtube-search-python" do
    url "https://files.pythonhosted.org/packages/91/3c/dc669b0308e49f294df67bddbb16ff3eefe5b5da6fa37ead922a8301926b/youtube-search-python-1.6.6.tar.gz"
    sha256 "4568d1d769ecd7eb4bb8365f04eec6e364c5f70eec7b3765f543daebb135fcf5"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/cf/41/53ad8c6e74d6627bd598dfbb8ad7c19d5405e438210ad0bbaf1b288387e7/yt_dlp-2025.11.12.tar.gz"
    sha256 "5f0795a6b8fc57a5c23332d67d6c6acf819a0b46b91a6324bae29414fa97f052"
  end

  def install
    virtualenv_install_with_resources

    # Build an `:all` bottle by adding a file only used in linux to macos
    (libexec/"share/applications").install "yewtube.desktop" if OS.mac?
  end

  test do
    assert_match "checkupdate set to False", shell_output("#{bin}/yt set checkupdate false, exit")
  end
end