class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/87/95/4910e17272db545b8c97854bdc509bfb7a48d16055c5247c8f566984438a/pipdeptree-2.29.0.tar.gz"
  sha256 "e21ea782b6266611a5505d76db2f187f43eb140248029e06b535928617f6847f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73d8fc297317a688d08f1bbd9eefa4f19f2c582addd10b6a4aee76ee6e498766"
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