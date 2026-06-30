class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/cd/e1/2d6b05488a1661c1acb3d987ac4dc032b0ea2f5821781ed5438efb10a28d/tmuxp-1.73.0.tar.gz"
  sha256 "504c58d210bb1c359e21243f98c64b31c327a83928e22d7cf0cca80db35e3d97"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37cc4cdd6444ef68b64586e28562bda7c776283c9d55326c844a6cef061ceb30"
    sha256 cellar: :any, arm64_sequoia: "380e3b703a83e90e790eef3bbf99d832fb7e62c430f2ee28d81f936a906c389c"
    sha256 cellar: :any, arm64_sonoma:  "1b616c1ace2f943fbc2381298ca6606aef95b81f520c55eba5e133fa8eaf8b71"
    sha256 cellar: :any, sonoma:        "ac4de67b0cbc28d3db8188ce9813040c701e661320a3edcac177e73deaf70854"
    sha256 cellar: :any, arm64_linux:   "76775d536b00afb09ca4ad37b7486fd483d165e366934339c19f776582252493"
    sha256 cellar: :any, x86_64_linux:  "58fd2928337290424efae00363085015d49a5e1cee918cbccc4fdda4b03c4c89"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/d0/e2/c2fc23e871855cb3feb5119ab3426656b2caa83f220fb6f1b7a770cb887e/libtmux-0.60.0.tar.gz"
    sha256 "03d9740fd18090378a1f1a763403b127808b327b1466a1d3812c562f595ce06f"
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