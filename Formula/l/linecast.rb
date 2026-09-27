class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/ba/ba/227c1df8ac84a934845681095ed54f9d22029b23c43bb19d1739addf244a/linecast-2.8.0.tar.gz"
  sha256 "0f1b7c8ce4a6ef7c31e8180ceb5ed8228685361030e9b33282199dc95940d09a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b08b8ad5c17fda1dc2cbb016c9c9211972748fafce5aeae12a5be6fb1d28bc80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b08b8ad5c17fda1dc2cbb016c9c9211972748fafce5aeae12a5be6fb1d28bc80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b08b8ad5c17fda1dc2cbb016c9c9211972748fafce5aeae12a5be6fb1d28bc80"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "509aeed8a0e3e46cf27f16ff6f9584bac97c476291d52e2135eb21c760da9413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "509aeed8a0e3e46cf27f16ff6f9584bac97c476291d52e2135eb21c760da9413"
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