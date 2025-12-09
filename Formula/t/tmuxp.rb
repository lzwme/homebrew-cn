class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/d0/8b/3630f1d037e62400faec860f8d98e83b734bd1bdef3e9a081ade298299b6/tmuxp-1.61.0.tar.gz"
  sha256 "b4355d35aff5da859f576407ee791b89a0404db97f8a16074cda0441152e11d2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32b81122569bc7d52d6777ea8dc83c8183abcf62f0eeb31af8931a7ace95a80f"
    sha256 cellar: :any,                 arm64_sequoia: "5b3e3267003950210da54db75951eaa014174feecf10362b97156e0c76df55f3"
    sha256 cellar: :any,                 arm64_sonoma:  "bf180057e302c3bec89f84d4fedb2a763a5fc62e704a47dfc1aa56dc2f9104d8"
    sha256 cellar: :any,                 sonoma:        "d473483434ba16d481e8e1a35776ba1fa4410847f3e7ff09b5f599d616c68f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c71e5638b41313c85aefcd46cc6755f87c1836407025bd3951d81e1b60bab287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cdc7e8ea6cb6ec74c078c4c09dc283bbaadb08f7d0c4844f3a4ca1e917f4ebe"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/94/1f/65921e53ddee1bd0225d19bb2930d0c1033e6c2b80a7ee0e4fb73862c189/libtmux-0.52.1.tar.gz"
    sha256 "01fc034f7ce62d75eb4dfb6a01475dd0f32f044d92f084431d1f2cd3b5b97506"
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