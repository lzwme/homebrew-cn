class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https:github.comasottilereorder-python-imports"
  url "https:files.pythonhosted.orgpackagesaef863ecf759c9149d7d7a8b612ebfe74901164dde9adcb1c40975ddc713db1creorder_python_imports-3.13.0.tar.gz"
  sha256 "994235fe9273373af6df7290de6a362a2426eb9bb800f5197367fe54b081f4d9"
  license "MIT"
  head "https:github.comasottilereorder-python-imports.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "438e4afc9465da45505b6c627fb9c58f68c4673e1f33914a82ccf255cc2ce182"
  end

  depends_on "python@3.12"

  resource "classify-imports" do
    url "https:files.pythonhosted.orgpackages7eb66cdc486fced92110a8166aa190b7d60435165119990fc2e187a56d15144bclassify_imports-4.2.0.tar.gz"
    sha256 "7abfb7ea92149b29d046bd34573d247ba6e68cc28100c801eba4af17964fc40e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system bin"reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath"test.py"))
  end
end