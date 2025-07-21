class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/25/61/0e855474eee22f06d8508aad787c1bb3f9fff28759e758c0da44f8549998/pipdeptree-2.28.0.tar.gz"
  sha256 "bae533e30249b1aa6d9cb315ef6f1c039e9adaa55d5b25438395cace5716eaa6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4186df680dd5e48dc0eb1b9ace7b83b092dde1d36d173a9d77e5f52bf833a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4186df680dd5e48dc0eb1b9ace7b83b092dde1d36d173a9d77e5f52bf833a9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4186df680dd5e48dc0eb1b9ace7b83b092dde1d36d173a9d77e5f52bf833a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d16f75593085ae5f9e5079a9347bc50a6544734bb3de8a39a87159059d156d9"
    sha256 cellar: :any_skip_relocation, ventura:       "9d16f75593085ae5f9e5079a9347bc50a6544734bb3de8a39a87159059d156d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4186df680dd5e48dc0eb1b9ace7b83b092dde1d36d173a9d77e5f52bf833a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4186df680dd5e48dc0eb1b9ace7b83b092dde1d36d173a9d77e5f52bf833a9f"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end