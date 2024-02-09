class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/81/09/2a966b33a6a2327b1de9e92d3025f4ba5c45f017d8c0be3fe712b82eee4c/tmuxp-1.36.0.tar.gz"
  sha256 "4c6a989514fb645b66c922975d10c5b94f92879faa97866d550c39988eacee03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6df53c879bc785cb2fe8f8b04e407104352ec494129c0a3fdd9cb83f0dc541fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b38cfd71c8fb918da84dcf46262e724e5464da675a7f8761148e2f83bf812a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c73713abaf13075f129f93044f267597bd650e3b5175499a51a16698e7d251c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "63228bc0f21d6d209bf34dfd79ae565d585f1529ce4addb1f6285a8d62f919e8"
    sha256 cellar: :any_skip_relocation, ventura:        "6fa44809e3b5f41ff21190a03c75f97ca8ddb4c2db18cb3a40dd0e2a44e74411"
    sha256 cellar: :any_skip_relocation, monterey:       "9a194974b97b3b75adf762d219cb9e1dcd5636f3bb96ad380d2749e4b7803ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f521c35bbe30b5ade0c42f8fefa2633bfd91d858dfbbc4835e9697d327262b"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/4d/0f/0bc042d2eeff292b69a8c5d42a770dc22fc1bb6d43b589ea9ada9cb304cb/libtmux-0.27.0.tar.gz"
    sha256 "c9da2f027015d7690051f2a29e8313be30c2a876cf68e5082964675edf7b8314"
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