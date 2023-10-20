class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/02/bf/1ee2d66a0ae97eb7fa893239a512a8a19058e325323828a591232f9dd8aa/trzsz-1.1.4.tar.gz"
  sha256 "942ad73d1c307880ab23fde569ab41191fce469d861b534826a8a1e07c4edf96"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93365e4d0fb1bf8015a9b11c8370b7b7858b7aa99365071b1428b52f1fc887ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42d837d3663936b7b858544b014dace5ce4528f82d886daa46639686a9b906b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0565b5fd2c7dff7e61d22d0499595cdb0e3d0eba73d20aacfbcd2ce452450bda"
    sha256 cellar: :any_skip_relocation, sonoma:         "6567f14556a2646469835d3688e6e479f3c4b19582895598982c5ca74ae06490"
    sha256 cellar: :any_skip_relocation, ventura:        "a80791c1ad7c1493260e7c8bc69eea6c528d99a92a8ce091bc0795bc305176ef"
    sha256 cellar: :any_skip_relocation, monterey:       "51d4449d117cc3d568b6ac5bc547bed75f83b96a01ce780f808434283e0edb7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ca1df3e1c0caa799fcab0567e9e2b98be6100bd708661f8cf2dbbb373d0f49"
  end

  depends_on "protobuf"
  depends_on "python@3.12"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/84/a7/13d3f511f73dd0de5f7f3c2abda51a3fe5acd9cd0afcff5281570e3df1dc/trzsz-iterm2-1.1.4.tar.gz"
    sha256 "27898b478283e42011066ab52e388c8f4de662ebb61b0ebab5efd92223d8ce63"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/ae/81/c1e3cc75c7bfa69bf5f190a8399be84fb59b871e182b0b90b2f8448b733d/trzsz-libs-1.1.4.tar.gz"
    sha256 "2c48a7268294ef535479823a3eaee801d9e4fb8ba2ac4f152f8396849c3f851f"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/22/a0/e9a530592ecc36d0ccc2dae6cabb45540d3b6da5bf5fb2d6dc79ae999544/trzsz-svr-1.1.4.tar.gz"
    sha256 "0cf4abda5a6832eebfeeeab4598fdd9fb5512fb6143442da17c54398af1a4e1e"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end