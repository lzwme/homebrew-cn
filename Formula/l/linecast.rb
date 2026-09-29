class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/84/a5/874827371051e8c4b5b04417df8a8fadd9317891d4e10bdf72cae6486347/linecast-2.9.1.tar.gz"
  sha256 "ac0d77a1483c84d062b775f8cc90e63bd166d0378930d46f9dfb29460b1bd4d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b577d2ca93e274b6716d6495e96f9924e98060a0c8bd5b8b84c0a3e96fd06bcb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b577d2ca93e274b6716d6495e96f9924e98060a0c8bd5b8b84c0a3e96fd06bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b577d2ca93e274b6716d6495e96f9924e98060a0c8bd5b8b84c0a3e96fd06bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f9866e73c5cc1aa94376300991946c816456dbad76b8266a2e36fd58f16b5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b577d2ca93e274b6716d6495e96f9924e98060a0c8bd5b8b84c0a3e96fd06bcb"
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