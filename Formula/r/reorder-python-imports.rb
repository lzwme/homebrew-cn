class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder-python-imports"
  url "https://files.pythonhosted.org/packages/e9/3e/56100d88371014a60d3b9185f29759e9c9947d97e79df3ded672fad2bfc1/reorder_python_imports-3.18.0.tar.gz"
  sha256 "89e73e4e30a6272117daedd5b2573d2e03f9a40bc9676999d2617c8618a3e34d"
  license "MIT"
  head "https://github.com/asottile/reorder-python-imports.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ccd1785d60285dd0b3f3aabc97f97b3154fc158fc0185eb2398d274a88c82ced"
  end

  depends_on "python@3.15"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/b5/ac/1223bc31ef2947227fe8c705efd005e6d06170cff33db3ccaef34ab98b69/classify_imports-4.5.0.tar.gz"
    sha256 "83af69ba9d4d05dd15146848d7b2cfa900a8f5cc81f26693688af73e8b199497"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from os import path
      import sys
    PYTHON
    system bin/"reorder-python-imports", "--exit-zero-even-if-changed", testpath/"test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end