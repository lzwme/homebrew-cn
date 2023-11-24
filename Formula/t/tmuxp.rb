class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/f1/93/649a0df1df4a1bd643d24e4a2fd002e6749c3a6408cd0bb5f945b666a7bb/tmuxp-1.32.1.tar.gz"
  sha256 "9b8d46a8e66481d8008a4b4107247ade1d004edf3fbed833ed69629b00fe8a94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad76284a0e4b90535dfb8c483306a4689f13539df9a14afce311394e89c39b9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9625c7494ab5caeaa54b9b5b6ae4ae27e9c2bbc458267320860e1f6e0afe965b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49e3e3a5cd97c0a84be8ddd7306eb6d92993c5cf64ada556bb9e2db269c68688"
    sha256 cellar: :any_skip_relocation, sonoma:         "d50305137f026e0fe64842b5d38cf9e154ced203e4077134de45fd4e549c2982"
    sha256 cellar: :any_skip_relocation, ventura:        "593cec8619a5c3298be12972f7337e07a868983b7ae26f80fee646c3be9d9972"
    sha256 cellar: :any_skip_relocation, monterey:       "782553db99da22954a473a8e3f67365004083c1db6f10eac1aea084f3d2e46b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2d81874960167bfd1608b18c3dec79d62f143b8d08106455db6e0decb4b38b4"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/99/0b/7af9a90fea74c48714802bb322f577d2df9d2eee7a5da9361e5c7e743e38/libtmux-0.24.1.tar.gz"
    sha256 "de4ab13836023d48e7d7db2b6a18f551b6c848f890c629483fc468f34591cf61"
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