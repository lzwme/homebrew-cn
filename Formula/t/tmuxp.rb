class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ca/6a/a3200410d5a1ad6b7dccb416fdba080bb5924e536f5764bde3642f6ca58e/tmuxp-1.55.0.tar.gz"
  sha256 "ade0bad3d9d8d647664089c0a6101f9924d9410aa2b530fcf0406fff8994de1d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c7940ba1fa8ac945ba218f0a90f998391e8070f6c948dedcc7cd2171f98cfdef"
    sha256 cellar: :any,                 arm64_sequoia: "477d67734d5b2fac9314e6c633f3fe477f7d82553963238f7ce815dc3baebbd7"
    sha256 cellar: :any,                 arm64_sonoma:  "718480df433b143251ba3d7c6e312cabb72dbcbe11c3055b20e2bee2fdb9969c"
    sha256 cellar: :any,                 sonoma:        "384724549c31734e6814e2138b55c1515d82a52a15a2db6c15675378df41de07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa8db5e24a2a09a8a5b9671fe226c42f59aaa7edaf79608246738b8cf9d8dc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4655a06f44187da5daf403e5710355abfc050cb95b87b67e6a2fb019f457bbf"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/9c/aa/7e1dcaa097156d6f3a7d8669be4389dced997feeb81744e3ff4681d65ee8/libtmux-0.46.2.tar.gz"
    sha256 "9a398fec5d714129c8344555d466e1a903dfc0f741ba07aabe75a8ceb25c5dda"
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