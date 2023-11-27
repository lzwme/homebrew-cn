class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/36/92/6ac4d61951ba507b499f674c90dfa7b48fa776b56f6f068507f8751c03f1/img2pdf-0.5.1.tar.gz"
  sha256 "73847e47242f4b5bd113c70049e03e03212936c2727cd2a8bf564229a67d0b95"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f54e7b8928dce6d4644f6184955572789432c1572c59e708b63d904b2dc8421"
    sha256 cellar: :any,                 arm64_ventura:  "d398f46e1214935b45cb6518e10992fb29cd97d3adc7de54feae7b101cc84a63"
    sha256 cellar: :any,                 arm64_monterey: "df91b380e73c7337f7bc503fcee69659d30b8932e4502a276189b5890813a653"
    sha256 cellar: :any,                 sonoma:         "6154675daaaf2b8b5eb1083e5d7b71c8d8fb7acc9f03f58d64d27b3697963654"
    sha256 cellar: :any,                 ventura:        "806a59e0f70e1407d8a6d3de0a5934e09ab1a2aa6f527dec26f5b382f26a1d53"
    sha256 cellar: :any,                 monterey:       "1c43195c36c1835f3591e9d1cbec90f8c804562b3a76752abd172b98a67c697c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ce080bb9a37bc6ad9e2acf94d5af39db30bb2ad75a2c0b5144ba6a90104d93f"
  end

  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "qpdf"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/38/e8/c7642da0b774d42a259bdb450aba0d34aee65bf3f6641c7a7f3c83ac7297/pikepdf-8.7.1.tar.gz"
    sha256 "69d69a93d07027e351996ef8232f26bba762d415206414e0ae3814be0aee0f7a"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
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