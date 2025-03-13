class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https:github.comtox-devpipdeptree"
  url "https:files.pythonhosted.orgpackages684bd8547814b41dc896063a1bcc3a48cef440d7da3d5d879c586ec7de65bdd3pipdeptree-2.25.1.tar.gz"
  sha256 "8fb788c97b8b605bdd105a6eb847bd762caa49c4942176b31eee162ba2cc7389"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d89d83cc573b8535cb665825c9d05733dcaafb5bfa3185075b31eadac5401926"
    sha256 cellar: :any_skip_relocation, ventura:       "d89d83cc573b8535cb665825c9d05733dcaafb5bfa3185075b31eadac5401926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}pipdeptree --all")

    assert_empty shell_output("#{bin}pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}pipdeptree --version").strip
  end
end