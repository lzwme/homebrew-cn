class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/31/2e/cf42e2d54f2472ce38d62df4067342669de9438ef145267d6d499cf49a5e/cpplint-2.0.1.tar.gz"
  sha256 "c258baa861a636421346f3db20b3b125c76b0fa8fc91857ee637a603101426c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78db1770d5901a73e2d2c23a01349035ea48fef9dac473c3c8a6b08a08f6e071"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    test_file = pkgshare/"samples/v8-sample/src/interface-descriptors.h"
    output = shell_output("#{bin}/cpplint #{test_file} 2>&1", 1)
    assert_match "Total errors found: 2", output
  end
end