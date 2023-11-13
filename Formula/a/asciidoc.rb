class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/8a/57/50180e0430fdb552539da9b5f96f1da6f09c4bfa951b39a6e1b4fbe37d75/asciidoc-10.2.0.tar.gz"
  sha256 "91ff1dd4c85af7b235d03e0860f0c4e79dd1ff580fb610668a39b5c77b4ccace"
  license "GPL-2.0-or-later"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d572ef00422334fba5642887f4105eb6d966bcc0f7e1ed72e3c1a7d81a3e6d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a63d6fe4b1b62644a832dc32e4b5cc568626237339f82efea9b33933e957a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6f388fc22a7cb0cf189c1f60cda0727ebab34d87fea51a3b0680702ac5c0ff5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b599255846848071776a5238e0c505956759e7066bc4e7f92399014f56c4d7b"
    sha256 cellar: :any_skip_relocation, ventura:        "a4c3074ac129b19507523cf0abe33d97fe7eaa5223c05602e5f51ffc17ccd059"
    sha256 cellar: :any_skip_relocation, monterey:       "4bd1bb2811ac2d28fc822776699e5e14c0533bf7eb3ac60e97b71c596b950b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "639ca69c03c6ff8b653b02fde67b3bfa828c8610956b9ae930e9cfecbd16911e"
  end

  depends_on "docbook"
  depends_on "python@3.12"
  depends_on "source-highlight"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      If you intend to process AsciiDoc files through an XML stage
      (such as a2x for manpage generation) you need to add something
      like:

        export XML_CATALOG_FILES=#{etc}/xml/catalog

      to your shell rc file so that xmllint can find AsciiDoc's
      catalog files.

      See `man 1 xmllint' for more.
    EOS
  end

  test do
    (testpath/"test.txt").write("== Hello World!")
    system "#{bin}/asciidoc", "-b", "html5", "-o", testpath/"test.html", testpath/"test.txt"
    assert_match %r{<h2 id="_hello_world">Hello World!</h2>}, File.read(testpath/"test.html")
  end
end