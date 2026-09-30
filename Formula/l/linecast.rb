class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/a0/df/89fc9ff6d5d737cba64c23c179293c5ac6339c655ae9f16662f927d8b5c9/linecast-2.9.2.tar.gz"
  sha256 "e403464cd7193806a6581ef3b4d4adf7e1498d1d015f6a47db4cbd6ea7cdb1f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50b8bf2912a26b8680aa149384279efdbb17b1a6454618297ba5824ad7247ee4"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end