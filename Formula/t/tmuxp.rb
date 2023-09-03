class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/8b/d0/8ce5dd49eb1be54a7870274b836117ff7a49f4b576044f3d836100e97390/tmuxp-1.29.1.tar.gz"
  sha256 "b82f004c77b1fb45d0e7f8c9dc0877cd109b0ec11cc65a8f766123c10f91270e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f14f937e179cc0ced66e638ee4d6abffc67c403440c53f270c6d4a742350e610"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab49de2c293926a0c0855c337032f682a5db845791268d5adb851bc211082329"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1c26c7d67e1c954ef0aefe6508dc15ecda1468f0ef86ef05005787989fa5478"
    sha256 cellar: :any_skip_relocation, ventura:        "af6911d29a8b9609e964a7308ef98ac7a9f5ab07ee5e22d2456241ca317cb3ec"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf04e9f0a247a40a2733ab1588f850b706af7039ee8392b707e32b8d32d2180"
    sha256 cellar: :any_skip_relocation, big_sur:        "3de75e3cc3bf8c0d764450e1338523c4bf3d99aa284954d12f189bc4a1e5c24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5f5f48550941e0f14ba62e4567f9641f78f40616e30ed52563023c9cd34363"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/7f/d8/8a4ed64d5b51aa2cf411d5fd25d7881d685b647f4416a2bf47943123ba02/libtmux-0.23.1.tar.gz"
    sha256 "398973268782376de8962ebe205c6b9601d3580f6541c6a1dd5e43f8c7e2dd82"
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