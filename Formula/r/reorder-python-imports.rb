class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/f2/a4/b9299bb0ce17c405fda20efa39f6993b418b10c765e978961f3c97254f4e/reorder_python_imports-3.12.0.tar.gz"
  sha256 "f93106a662b0c034ca81c91fd1c2f21a1e94ece47c9f192672e2a13c8ec1856c"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b3a21e974205812118ec179bdbc0d8ab0c921629b8550845fb23ad13ed3ca58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1d2f800916c0ec2b54551d587e6ef0c9c5708d5329994b66f0463eebc00b0d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c830b0252795f821b689e746c1c9138e1ce0d51d77f4161a9119590c585703ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "524a17481bfcb8cc9af6526bba3b95b02b39c7fac5e911d10b2b68025bd813a8"
    sha256 cellar: :any_skip_relocation, ventura:        "34ca800b0a39ef54a5df5e38ddd6287997a25d14da17802a8e2fcdc2ca031aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "da02e4f1338ee0f8b9d39558f01a6d58dbfc4355130a595a27c6078145f69231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadc175aa8038915435cb89a4c7c0c64af337a11d53a2bb5dfedfbe900565597"
  end

  depends_on "python@3.11"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/7e/b6/6cdc486fced92110a8166aa190b7d60435165119990fc2e187a56d15144b/classify_imports-4.2.0.tar.gz"
    sha256 "7abfb7ea92149b29d046bd34573d247ba6e68cc28100c801eba4af17964fc40e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end