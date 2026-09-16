class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/e1/ce/6db0cf2d313393063558af3bd17aa94785eee128d5f828de063c689eee69/linecast-2.5.2.tar.gz"
  sha256 "c0cf6d03cf43cff7ba5d1cce53edb14d1924284717af97028d8e77128cccc9fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d2a26d969c6e99136bd37f53a47b42adbfc687858aceeadfec1f6245ef0b0b0"
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