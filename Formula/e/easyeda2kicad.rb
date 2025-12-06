class Easyeda2kicad < Formula
  include Language::Python::Virtualenv

  desc "Converts electronic components from EasyEDA or LCSC to a KiCad library"
  homepage "https://github.com/uPesy/easyeda2kicad.py"
  url "https://files.pythonhosted.org/packages/f1/78/fde265892294c733590a9089f37cc8ea1478b9c632d76c0a11b8f20fe6f3/easyeda2kicad-0.8.0.tar.gz"
  sha256 "a781be6d1076f6e06886a4292373eb930c9921de4c709d6dd91bb6ea104f4a4b"
  license "AGPL-3.0-or-later"
  revision 3
  head "https://github.com/uPesy/easyeda2kicad.py.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6cc11ff9d72cc0f07cd0fcdd5271f1fdd76d93e7482783a90654eda38a4795fe"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"easyeda2kicad", "--full", "--lcsc_id=C2040", "--output", testpath/"lib"
    assert_path_exists testpath/"lib.3dshapes"
    assert_path_exists testpath/"lib.kicad_sym"
    assert_path_exists testpath/"lib.pretty"
  end
end