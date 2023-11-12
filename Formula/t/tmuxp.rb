class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ee/13/6452d38f37427c700cb7bf7b1e1d9aea555258c126879dea0f4560d3d917/tmuxp-1.31.0.tar.gz"
  sha256 "263977a1eea6d05ee138c232028f7ec6d4c17dea9ed8fc2eab73666ad859aa73"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdaf3b4de5af1faf10ed91a3e623ef3907323c912d07ff8e3071684533cfdd11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac0def26a4d794effe447e5fe5aaa56407825e0caca456fe86ad31fb44c2704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4052a90329772a793c4fa64c0ec375a1e8121710511466be4ea259933aef5ad1"
    sha256 cellar: :any_skip_relocation, sonoma:         "44c078127fa300f0e6731fdd400edacb0c8bba87922098b657488a9dd920f122"
    sha256 cellar: :any_skip_relocation, ventura:        "52fd8a22d2744d9fad6a8c7dddd7f4ade853141715916e76917d798e261a9181"
    sha256 cellar: :any_skip_relocation, monterey:       "a61cffa5a5ebcccca2b948206ef7dad13e1ad1c1a9a8c95aab6fb3cb1fbc8cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61f2be9f953a12a23b186a8613f513c7b1f4e2b6c351dd2f9b187d45f51f06f8"
  end

  depends_on "python@3.12"
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