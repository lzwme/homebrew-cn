class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https:github.comnickstenninghoncho"
  url "https:files.pythonhosted.orgpackages65c8d860888358bf5c8a6e7d78d1b508b59b0e255afd5655f243b8f65166dafdhoncho-2.0.0.tar.gz"
  sha256 "af3815c03c634bf67d50f114253ea9fef72ecff26e4fd06b29234789ac5b8b2e"
  license "MIT"
  head "https:github.comnickstenninghoncho.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "feba34ae5b4a5ffb87f747dbabdaadbc59babdc16a8e002ecb903359235552b6"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"Procfile").write "talk: echo $MY_VAR"
    (testpath".env").write "MY_VAR=hi"
    assert_match(talk\.\d+ \| hi, shell_output("#{bin}honcho start"))
  end
end