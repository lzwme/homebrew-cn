class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/c3/0c/f8d29097a9e1a0b8dfc874477470bd68009a282f06ef334ad94767649cce/tmuxp-1.30.1.tar.gz"
  sha256 "c94123a0ed19c8c54b120a1d92f386aecf4adaf95184decc10d6441f36c446a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08a979ee5f5334be1325e6a9db50f89afc04054f1f5c85230c1cca13378e064d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c82922254462065b9cbc8b9fb8e221f0aec0c2ac8e99a09615fc10679c0abda9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8ba81af6c85a61c8094ab547966b370ffedf07157c2e0166a94ecd463942ded"
    sha256 cellar: :any_skip_relocation, ventura:        "4c24c65b5b14af32a3dbeec961f880e0710c8116600254f2571425d670d68118"
    sha256 cellar: :any_skip_relocation, monterey:       "3068aa51db9040db02299c357201035decabe3878439188ff4426be1a7ba7497"
    sha256 cellar: :any_skip_relocation, big_sur:        "12c8fdda5961fe6a32c7b6dd918993285367c3844a00219c4e13396c07a6194e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "373256afdf6212aed004e533d1e797bf56dfcecaacd256f156e78fca88123634"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/21/99/5f1d5d24a1fbccb79b036bbf0d47f48d5db1a43266082eff8b5eaaf5afe6/libtmux-0.23.2.tar.gz"
    sha256 "eb3e8fb803e4e7c9ce515c93a95145aa6a0b58ddb2ae532daf9fad879609971d"
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