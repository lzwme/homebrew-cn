class Easyeda2kicad < Formula
  include Language::Python::Virtualenv

  desc "Converts electronic components from EasyEDA or LCSC to a KiCad library"
  homepage "https://github.com/uPesy/easyeda2kicad.py"
  url "https://files.pythonhosted.org/packages/f1/78/fde265892294c733590a9089f37cc8ea1478b9c632d76c0a11b8f20fe6f3/easyeda2kicad-0.8.0.tar.gz"
  sha256 "a781be6d1076f6e06886a4292373eb930c9921de4c709d6dd91bb6ea104f4a4b"
  license "AGPL-3.0-or-later"
  revision 2
  head "https://github.com/uPesy/easyeda2kicad.py.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "fef36a0d6772f498a58f8dd65683dd7fcad415f7ca4a26413467073e589e6b02"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic-core" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic-core"]

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f3/1e/4f0a3233767010308f2fd6bd0814597e3f63f1dc98304a9112b8759df4ff/pydantic-2.12.3.tar.gz"
    sha256 "1da1c82b0fc140bb0103bc1441ffe062154c8d38491189751ee00fd8ca65ce74"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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