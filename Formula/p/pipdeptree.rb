class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/b5/82/127215bd6bf6f1c0d98c89052eb91c67e34258b743395e3ebd24bc7a3816/pipdeptree-2.13.1.tar.gz"
  sha256 "1e1acdb2ddc2abdca1718f27ca8dc21622c896a00b8980ec3d42c2208a841a10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90b7f8bf3cdaf6d3f23e245c567232569d13fc0ae32dbe7a8b9601ad3515f704"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62e5731da4ce37940236fa8bcef7d2799dccd31385cd9bab62a30c02f7940c74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bba9b352fde87832102ae090312dd60b10bb8c650f044514d6f3bb6e3cc25f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8a837982335847a6960824725cb72a79f9270f46208c203f44ddd33eda465b8"
    sha256 cellar: :any_skip_relocation, ventura:        "4efe0458cd6a39fe1b7d54cb9bb8b0abc1dc2c170fb90bbc8640dc7f870f9dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7d1dc1a69be476aa5f0b24bb94c4780b50bce495c95e0d53f9c0b22fd97c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7728632f6ed06a47f59dcd8f066de490b51175eddc425e666f7739d1be58b74d"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end