class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/50/3f/191014dc6cf38e38047108c2c49ca8c6d1c4ef9f7decf7c74dde6efb0f56/linecast-2.6.0.tar.gz"
  sha256 "e6ef51112494df555c8d3412c741f1dda7536717eaba45d9fec366b8808cb48d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b229d410d45652e3047c71fd146a5f7d60cbb6a2d878d67b49be5b0f1abf8b89"
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