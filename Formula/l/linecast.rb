class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/29/c7/8bc090e9ce31313df723aaea5fde3fe148b3793854f1ddb3abbcc0244c36/linecast-2.1.0.tar.gz"
  sha256 "4c278f791905ed22ae065ed089ce7f81fcaa412e2abcb740ed190af833e99cca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1be370f66bc66e8fc676945a77a8b5d3aafb2a85556906b0fdb36e0de2a900f2"
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