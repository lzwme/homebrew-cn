class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/e4/24/09cbb97f2dc66f5e89c039451051f94422f3846fe84f8334bc23acc19e57/linecast-2.6.1.tar.gz"
  sha256 "3cbe168d29bf73130a1c93106b32e498a42a28b3e7745c90122ec6e2c2cbe8b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d92a7cefb5fe3c0bba8cecff6c116db61adeb6fb281ecb41dd3f8bc0fbb6274f"
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