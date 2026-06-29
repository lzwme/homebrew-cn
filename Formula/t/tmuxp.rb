class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/94/6c/11511988cd537976448ce8bc5c58978d63094b95a6be9f71f6a533d1c9d2/tmuxp-1.71.0.tar.gz"
  sha256 "f8db2be2035e9bf801e9932b7b9deb7ee33c2b0922bbce9a1899abc62151a2b6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc8f9abfb2fee4b59a226f6927ee900c0594694416085a9109bd242b4fd23ff3"
    sha256 cellar: :any, arm64_sequoia: "4bb9bb7ff98bc3bb4bab82bee451b72ee6bebbf339ff578f824c277e6d319e94"
    sha256 cellar: :any, arm64_sonoma:  "c58f2c5f60d68224e45c3ad9ea8b0822610c57609503ee4e90cb084260917d1e"
    sha256 cellar: :any, sonoma:        "801ef377d0208838f957aedc5236b6e382e4afc7a6974ebbd0ff0be8601226a7"
    sha256 cellar: :any, arm64_linux:   "75c9ccbd0cae347e2cf5d045f84155fcd385a4a09fccf27413848287a09fb717"
    sha256 cellar: :any, x86_64_linux:  "f693e0781e3cc1c589062b39c23e19f20bf2519048a58037ccbed26a0e39b207"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/3b/a3/4112c3e30f7620eaaef9e7445dc1c040a006ad83a071697136652014ea5a/libtmux-0.59.0.tar.gz"
    sha256 "bc279de9626408a5460c752ef1cc1884fc93ad00f5cc43a6170f619bc1617cf1"
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