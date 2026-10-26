class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/2f/ee/3e5b6d5e785e2754169466f3bbb6b5f5951f58c49d42b39992c87f62021b/linecast-2.11.0.tar.gz"
  sha256 "4bf7717635a662559b40bb85a5fc90dc5f55451bada18071bbfc030a681f0391"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60f85150e0129d2b3c3950c68b1a649514c94951142401d318d6af8a332c8e56"
  end

  depends_on "python@3.15"

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