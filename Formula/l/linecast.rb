class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/cd/f1/b8881fd4fc0ab3b4584ef239ff4c05305bc5825909195c0f5c699f5b8c59/linecast-2.3.0.tar.gz"
  sha256 "65267e70821901c6c6901d94969e21928670b4deece4f366e3951f8837237140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c342342bd76fcf8848bf073fc3b748e85ded3fa6069b07790cb1f4b1a97757ad"
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