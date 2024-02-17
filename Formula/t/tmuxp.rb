class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/e0/7a/5c371e49624597c69e1b4cc91978ec6cc374eb1aa3174e872284516c9ed7/tmuxp-1.38.0.tar.gz"
  sha256 "96220a16f8cb807e7caa404d701c65655f22ea82260342a55e42070b74163015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b3c985455eec352a816129e4331ad2f363a6f6a2ea004528a2856103292b7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19cf269c6882c00f32109226b7f7b29081db01475e65dd27f1846616165de7d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e0d3b8bc06ead0f27f3ba9937a2dcff090f39095f268ac510e0e61e6bad6648"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f6aa6250d808355f96cc887bddc2c331b55f2a2d5bc690737f473073addac33"
    sha256 cellar: :any_skip_relocation, ventura:        "71e65a908ce52cb3ab603b476bb443b2f09b61291e9ece7573d1b8b91abfeb06"
    sha256 cellar: :any_skip_relocation, monterey:       "8f46de85f8ae949eb7027a8cfe7be3df13d05db4657c125fb800b42dbea68108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f8f0af762d415d43e6322c00cd8040d54872271fbb0155554a45d22ddac57af"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/09/41/e5202b860a6c239874227c311eacb0f66b2ee6add669a16973184c8952f8/libtmux-0.30.1.tar.gz"
    sha256 "652d74d614963a7cc3a6617e7d0601e196fd0e55f9d074ab441bf6879ca462f3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end