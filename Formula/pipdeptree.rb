class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/38/ab/786755726dc0de69d4b8e947ba77230c2e7ee75fbcb058183c0fef08361f/pipdeptree-2.10.2.tar.gz"
  sha256 "0d64fe4e9573d3e992fc84f8dc025bd9cfdf00ce9850c1252dcbdbd1734d324d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2f4f242742cd3fa36617faa07b138c898fc5e1d61d9b6ae8260365c5595adff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38592594daddc0257517c9a5fddb4e13355fabe6336501efed7ca527042dc8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f6b9d1127f09f175c6f91d706f842de0a8ca510cbb06762cab7b4ff9d471250"
    sha256 cellar: :any_skip_relocation, ventura:        "dca0675be7b2c02f302747f3682935ef997a10ed0782ce4ed67cee7b29b99435"
    sha256 cellar: :any_skip_relocation, monterey:       "ffb72a090149d3a50b9042b21b084d138f9da9757e4b314c17a68c1a9536680d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dae882e829ec0d9ca7a1ce0509db6fff7b191b757c93e748ac974d5b937a7a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab26571ed0d50383c7801867839c59cbf4de98e549337df5588c29487821f7d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end