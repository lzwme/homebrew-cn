class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/5f/47/9b86219aceb0fc3fab7466f1805ae04f3f11b74c561d1170c01d6f7a3e00/tmuxp-1.57.0.tar.gz"
  sha256 "74b1ea6873ec64253d8f2dda9eb25d6b9bbb22d5c7f91568f553ecaf2756b25f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f16c914b4a49b4740ffc5f2d1d990b031bb5b1ce6d37bdaf525d83d3985cd489"
    sha256 cellar: :any,                 arm64_sequoia: "b737f150880f091df3ece46468e93a59584ce8f312ce8d886c32f88585873458"
    sha256 cellar: :any,                 arm64_sonoma:  "1342c292614f0064d2b0648838ce11584c90e911e19ec0b12446540dd72138e1"
    sha256 cellar: :any,                 sonoma:        "1c54df5fa2ab337f774c199587b4bde0918062cf0e9aec8ac0c49e528c29cde4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ece410205ca061cacc0b9f5915626e73dbb5c884eb873a1c3b13eeeb61b58b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920cca799efa12cc1630074143033bb346bcaefa2fa2a4e04658f2d5fe2c1970"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/7d/6a/fd2c9b22d34d4da6e470a3902fc81d016786f7d85e63f4f3067049dbcc8e/libtmux-0.48.0.post0.tar.gz"
    sha256 "8f63a914daebb12d6f941232287e6872e923032bc7a0950d50f4c2eed513da86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_path_exists testpath/"test_session.json"
  end
end