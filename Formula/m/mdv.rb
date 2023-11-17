class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf551327ed54191a4305cc7872250dc40d5ef3ccbc24a61d2cda9989b4f3dac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5036d6657a0ebb6e020cffa0958b7c9b7f367544bc5de52e9a94da7c93fffea3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8126dddeeb05b9f2e0a2790aa86428c79d6688ffa83900244d0df88e221bf18b"
    sha256 cellar: :any_skip_relocation, sonoma:         "61844e454dfaee1d13b0c685c2d97a62348f74a7c4b20fbcd0a5bfd1fcdc1811"
    sha256 cellar: :any_skip_relocation, ventura:        "45d781475ff78c917bad0349fd0ce7a33308fce1277e6c98c8885d42e7b5e20a"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c4764a5e4ed91c40f8a0a687a99b451768af512ae86d15117920fff2417ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72c632fd1912834de9619d7e0ec08575df9dc7ecf469f90fee07335c5c0d804"
  end

  depends_on "python-setuptools" => :build
  depends_on "pygments"
  depends_on "python-markdown"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end