class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/0b/b2/f01cf4e3c475864d4cbe49d46352c22dcdf364df3ccd0faf7b949bc38f07/tmuxp-1.60.1.tar.gz"
  sha256 "b629422e27cec0cd30f4ddabcefd817938060b1c3a7b60889e1a7be5bc855fb4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9e961b3f6a051988c2190d7d05f882ed301173fda5d9458a9a750ffd85e614f"
    sha256 cellar: :any,                 arm64_sequoia: "672b360c5d46aa007158556c7a2235b67f7706d069ab85ad18fa2cececfb202a"
    sha256 cellar: :any,                 arm64_sonoma:  "9d353c748a22ec4031eb5acd8cd95a6d24327b3ed27cd62e22c91f1325ec12cb"
    sha256 cellar: :any,                 sonoma:        "183ed2c38d9eed93d3106102b30258bbc0e5b1098d248cf2bc5032797b8679d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5720723bf18c0b0c15a8ef483fb686025b8f77405a2a06cda55be420f796870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6be956003ada6e07f299f6a991bcad62756880be00aac854650f0a166233ceeb"
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