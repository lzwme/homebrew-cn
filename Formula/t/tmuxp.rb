class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/a6/00/da6a9c5200ae41a46a65d456593f948b8508183ef47ec37a28fc0cf51dfc/tmuxp-1.40.0.tar.gz"
  sha256 "18929559978d3c49e6d0cc560c1213849cf1643dabbf82b11f8cc9d454a7e852"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d782e189f1565469289a551de742414133a9818be42774ae80bc06da3acd3da"
    sha256 cellar: :any,                 arm64_ventura:  "757b54ca9675d2b678615b7ee64c593c322826a9e4ca7dd60cb6653d5728eaca"
    sha256 cellar: :any,                 arm64_monterey: "684d4b50b147fb2b912a7e115de0ee2a9ad2d5c575937279f44639693099566d"
    sha256 cellar: :any,                 sonoma:         "28e67483a6976ae7bd3597cc680f6afb2c2e5fdc9fb1eafa0f4215726c95fd04"
    sha256 cellar: :any,                 ventura:        "df157fe8c4965bf67efeb9159ccd71472db2482a4a823e4f8e5ce142a0a27a8b"
    sha256 cellar: :any,                 monterey:       "cfe2ab63a295605c83ca02b375b6de6cc754c03ad071d35b40a749e74537c68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98631ff6c903b8eb943f02a2455b66d55638f1af5150cdaa09b4573b022403a1"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/5a/7f/8b8558a225ce13147e239e3309178dbfd88c6876bb66e0396a8308906286/libtmux-0.32.0.tar.gz"
    sha256 "49b47ef388085dd7caf34034021abda6a0c15df5c1cf2e16f1d3ed52e607d88e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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