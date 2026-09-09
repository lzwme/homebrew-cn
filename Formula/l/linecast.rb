class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/fb/76/7a15f60a89357db13211d593abee925470b07a93ba692b18783d8182dc70/linecast-2.3.3.tar.gz"
  sha256 "29edaed3151969b4055fd52b3fe65e4ca552c6df875f9cc782d9c720ad002c66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e82ac3ed794ffc3a7986f67d5a7808a9892754fd152b6425c6531df33d2bc2f7"
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