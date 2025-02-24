class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/37/e9/c80a0c496b5bc497f6e1407891a66d38c36d5f6f813c4106d5ec4addb514/tmuxp-1.54.0.tar.gz"
  sha256 "92df3d282994c6b0cf8075907522e7de59e0055b30997e377094884c39b806af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72095035ccd9deb740e2d8f4a59ca44c224ae425d45358f737ba33ffc1140980"
    sha256 cellar: :any,                 arm64_sonoma:  "b589e7e4ca1f36b7b3e232ecff7e860a240b5e8dce830ea02577c5be0772be22"
    sha256 cellar: :any,                 arm64_ventura: "74ae2c979e8d459637a9c53e442af51b8b581f4b5c269a01d484bd5bc994e176"
    sha256 cellar: :any,                 sonoma:        "2f3dda11c6fef4feb0203f985f9bcdb3d76687cca3d737594735f114ab529d1d"
    sha256 cellar: :any,                 ventura:       "7f99ecee93b9c6f20e2fff1264436a41f61dd22155ac8e29e33a316351685de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9b0743ec34d16cb1b213cf0e6827f664b4bc8cc7f1dcdb50081a6e3b3b9eba"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e3/f0/d346cbfad84f6c807642be44a777429ec6bae7685d1255168ac16d1b8e57/libtmux-0.45.0.tar.gz"
    sha256 "7f13a5fda3eef37f87f6b44692da290032cf3dbabb9e65699dd578f49f70bc8f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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