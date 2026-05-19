class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/22/6e/17cf2810ff928751bb678cbff3b44cf02b6a4229c45130e48116f04625cd/pipdeptree-2.35.3.tar.gz"
  sha256 "73238b3336698032abdabaa5508c404ce8c293ec7dcaa41e96c3d14734ce9f72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "edf7cfbc5c4563160980d3837faaaee78639f315821ec8449f3efee75ed0028f"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end