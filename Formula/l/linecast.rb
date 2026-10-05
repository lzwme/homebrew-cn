class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/da/c9/e240a287086ca30c1f149581f924b1a881aa8886c3ee2bd6b3a68a189ea4/linecast-2.10.0.tar.gz"
  sha256 "74fe8dc1b96418f98f392da113378fc5ac43e4e4d92c2f22bdff513eb63727e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30493b7b5bad037c019df87a4e1517cc307d16e56bd32b0bb91256f0c3fa8036"
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