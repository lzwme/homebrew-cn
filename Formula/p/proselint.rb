class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "https://github.com/amperser/proselint"
  url "https://files.pythonhosted.org/packages/58/66/bc509b61df9a317689f6a87679f2f9f625f6f02dfb9d0e220bd41f121f07/proselint-0.14.0.tar.gz"
  sha256 "624964272bea14767e5df2561d87dd30767938c8cb52fb23585bc37580680e86"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "eca80d4fc32861309f11f5a4c36ae7b2ec898d803e5dba3bb4ac7eed0be5902b"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"proselint", shell_parameter_format: :click)
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.", 1)
    assert_match "Comparison of an uncomparable", output
  end
end