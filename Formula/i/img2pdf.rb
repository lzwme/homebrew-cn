class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/56/a4/755e7c296d6e24e3e40b0f98e639ee93be1bd91c62ed698bbc7ceec420f6/img2pdf-0.5.0.tar.gz"
  sha256 "ae6c19731bde2551356c178bf356ca118ac32a232c737a14b423f8039df3c24b"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "492b0d07a574f776f02af896bdaff257492d086ee6dfaddf9d7f07ff735b5716"
    sha256 cellar: :any,                 arm64_ventura:  "309b4c9fd9da6b1bb858d01124e3961c59605580bd902278d5f4f0e6e6cd0c53"
    sha256 cellar: :any,                 arm64_monterey: "f632abe8306b30d27742dcdc201985ef0a389b96bb70896aac697506a45d39ae"
    sha256 cellar: :any,                 sonoma:         "36f941f12619c369374271d943d922ff46050f60d1307c5215e68e32b114401a"
    sha256 cellar: :any,                 ventura:        "b42e9e40a5c2dd209bab9bf759b0eb007225e73f9abd8716448f4e863497155a"
    sha256 cellar: :any,                 monterey:       "74c4047679ebcb7b918cb02a6938d19dc49b1cbda519294487173fe83acf6a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e6e6fcc37339427d439ec1be62ca53f436cf8e391833e8597b131deb3257f47"
  end

  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "qpdf"

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/25/03/5d12db46d10d6f8979edaedf286f7c4f399c8b022ed653c5f78f6a74e0f4/pikepdf-8.5.3.tar.gz"
    sha256 "7b4303e9000375b4f6ff51779bd5ca72aba3befb01cfdb5530f4ebabdde3f82b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end