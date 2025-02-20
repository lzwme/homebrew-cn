class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/c0/16/079beef0978db4280c3664b4a087f4539ad932a2cffd8afd2587f33e56ff/tmuxp-1.53.0.tar.gz"
  sha256 "fadd7d1407e2ef7d7f1be6322d81c8d806a680ce04864c37db3c916b02461363"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec4b4b0f885343324231fef693d181ca5fb131f4686f6febc140a29b15f56e7e"
    sha256 cellar: :any,                 arm64_sonoma:  "3ffb57b442621765a898b8ebf42c99c4c2e225ee31ac37b56f0dd91d51590a6a"
    sha256 cellar: :any,                 arm64_ventura: "a39956f7f21345ac3edc45a740f8d7f5dce57c8422b46d3b491b829a078a7069"
    sha256 cellar: :any,                 sonoma:        "ed55647e993701b88f25889f89c2f82e143afeeae0c33aad534b720e24ca1115"
    sha256 cellar: :any,                 ventura:       "146f51fe576863d5752ec04e7ce53aea24269e6523aa950476d0eb920f0f486c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de7bf82cf9395c6116afa0dc008fdcc44ea56407b62d9ecfbdf90be1be47e84"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/87/f4/66056457031778ba8191cde30144f6a1a2d29c73713a646800a046e1a35b/libtmux-0.44.2.tar.gz"
    sha256 "fb606c4ab3236d30cdaba6a88cc8e74b9cf28df993b183f4a5a1afdd313ee824"
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