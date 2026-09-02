class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/1b/5c/0e1ca366b72def17d1ba0127f477a2c3abf527512b04893ffa1d65cbf62b/linecast-2.2.0.tar.gz"
  sha256 "940876269fd7506acfc9c848ea3d361e77082ed18cf2335429bbd0ed17bd082d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d9b462b9094a297d4b49b82607913c29153e493f6be6dae4fd653bcd6d4a006"
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