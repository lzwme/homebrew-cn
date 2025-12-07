class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/a1/a8/b042d35f9f010633020b54da990b586f36b85161590043c6770b549c7fad/tmuxp-1.60.0.tar.gz"
  sha256 "b70d05f561eac9f970cc31b5f55a9f45728ffabf611f3e15111af9a49427c445"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bac371b7121fdeffbbe018f5ab7f7093c3dfba9ec7d2457ffe5c2f3397fbd3e6"
    sha256 cellar: :any,                 arm64_sequoia: "a5272ffaa0f51791224a1fc97af8ba9fee3361b6af0e80e5d2bc26dbe18fa8df"
    sha256 cellar: :any,                 arm64_sonoma:  "3d0d3d279a2fe56a5dd78180f7a36cd6ab7d3131a28de0c07efb13cfaa9fdac3"
    sha256 cellar: :any,                 sonoma:        "eb297469deec34acf7bbacb84e236f18b15425f1373db1d21e0ed22375bd2c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac581eef33f93cb8b7526a2027bc1195fd5020c295b17aacb2298cf72da1dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a943b13fd23240ae2b33463a19c00df18fc2119b57a20b47a52e642334e94ddd"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/fc/fd/dfc5fff48128a4790fd69a55d10024f4a322e4a6ef4564c221dfa71df4cf/libtmux-0.51.0.tar.gz"
    sha256 "4f75bb8692163374adbdba451a4959834b542c2b749892d9139624d478fc1771"
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