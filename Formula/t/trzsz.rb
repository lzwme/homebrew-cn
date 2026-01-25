class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/22/1e/40a495c84a0dc625a4d97638c5cae308306718c493f480ee5ac64801947b/trzsz-1.1.5.tar.gz"
  sha256 "57be064b259d57326f75683704b8e93a56ce0d67d9b3b2b36ad4d53e98a28854"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b53eb96bf24109ca3361d1100ccaffc7a96e87d4471470d5a22c6196f894767d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31641794cb5aeb07b28545ec68ec9a92ee60cf8fc302377416eef5f571913f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9785d8fb896ea637760176fe66011a2c93057f57ab235536d32608747ebe38"
    sha256 cellar: :any_skip_relocation, sonoma:        "e862bc307c4434aec3ac573118820aad2a05ab3488f5f5d1a6d64ce60d688445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1ff38e5d3473b2cc82ba2f15a60188d7df95cb7c6218a713cf4d1d3f3eca647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9b00b90344932762d829c1e1fcb49c4d3d058bd5c8b0e3114323006975fdf0"
  end

  depends_on "python@3.14"

  conflicts_with "trzsz-go", because: "both install `trz`, `tsz` binaries"

  pypi_packages extra_packages: "trzsz-iterm2"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/2b/56/4b11d23db523512eb827ca021b4974885f196ef585b4cd1ba0f17a6996ce/iterm2-2.13.tar.gz"
    sha256 "bec94392511358d94e7c3f84e31bcc380257cb261856cf7f08a1e4e563d7237e"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/53/b8/cda15d9d46d03d4aa3a67cb6bffe05173440ccf86a9541afaf7ac59a1b6b/protobuf-6.33.4.tar.gz"
    sha256 "dc2e61bca3b10470c1912d166fe0af67bfc20eb55971dcef8dfa48ce14f0ed91"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/1e/21/e8c12001396080263407277edc85ba765ee18bed54ae6d72e83516de7d9c/trzsz-iterm2-1.1.5.tar.gz"
    sha256 "a7f6fb6359523d871d03be099a876043d039458cb6086d22d1e0f3e874283c4b"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/f2/c2/89cfeb038585c18e320ede2182d70096a162f22298e29b7f1234bbc5230e/trzsz-libs-1.1.5.tar.gz"
    sha256 "baff5cea450e1310a292f5702d4a8f7dc855fbe2aefe21b13d2451bc05cedea4"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/76/c7/78c1c91eeb99c86dd80d903cdb463da0d1fbea9b7f25a1c1de5b0f96ecf5/trzsz-svr-1.1.5.tar.gz"
    sha256 "2f1fbc119df3c6010bf7b030635a5dc3cc1513025e5d0415d84d2d2a417b077f"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
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