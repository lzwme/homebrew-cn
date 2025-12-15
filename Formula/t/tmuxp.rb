class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/1e/29/33d7c77aa003eec2a503da1e18bac3b75ea12f4f15438d29c121aadf6387/tmuxp-1.62.0.tar.gz"
  sha256 "6cece0720ff9a29fca07b2330bcbf06720613828f97bd163ff235a9d30dfec19"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "919a5761be027187353c376686d22d576aac4bc57fc8c2094320c9e602dea179"
    sha256 cellar: :any,                 arm64_sequoia: "8542273ac6b7f77c578bd77c9fc64b63bd787d48a0ffcd833bb2a1afbc9dff52"
    sha256 cellar: :any,                 arm64_sonoma:  "4058ebd27c6bcbc57924d3873ef5ea8c10d95fd8b8e60827dd250506ed4fd37f"
    sha256 cellar: :any,                 sonoma:        "8458e596084f44b8a3e3b208c0966befb8a6a8e6b77cccf30c19673b7f13d5d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37c8dcbc09da91c2c8ee93e0ea9d604570a0fcc648bc43acdd1b456ffa47eded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87153a41fc16fc697f0642348c4a684c198760aae7b408e252dd57c542ce3d82"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e7/28/e2b252817cb181aec2f42fe2d1d7fac5ec9c4d15bfb2b8ea4bd1179e4244/libtmux-0.53.0.tar.gz"
    sha256 "1d19af4cea0c19543954d7e7317c7025c0739b029cccbe3b843212fae238f1bd"
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