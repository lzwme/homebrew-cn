class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/f6/be/02e33ef96d7822b40b1996f6105b8269027096b6c2af4abeacf0c9b59093/linecast-2.3.2.tar.gz"
  sha256 "84cbe5a3bb927d9e1f6aecb8e1bca6848b403a27977a32dd8aae3aea060414c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff48f4e991927fbbcad4b1365f2c98d8ecd3d619b78c45d2e2212b726d5243b7"
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