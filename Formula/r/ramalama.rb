class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/93/54/0cb849ecca09f127dcb221293bca15e7fddf57d749d4783b0a6f77b6dba7/ramalama-0.21.0.tar.gz"
  sha256 "03a8bd4dfa85089ca70cd4dd6b2ae433a5d3bcbb87cab1fc36185156b627642e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46cc25622d9076634f3c6435d3d588c8e04e4003078287c91e838be7a3fa5c9b"
    sha256 cellar: :any,                 arm64_sequoia: "5fa66f11d10205fe8bd5caa33dd1fbb9269fa034083b4d854bf1a14941fcda57"
    sha256 cellar: :any,                 arm64_sonoma:  "c31a9f5a9383d2321030d188da341ecfd537d24e16ab08ff0375ae294a2f214d"
    sha256 cellar: :any,                 sonoma:        "e83639ae63b2668044884415dcde5b816398801ec5f72f6dd22e37b9776efbf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba0bf24d5bf78a8641f132aba7faebe5575958bc4281653350aa04055c7d2a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "161a14afb8aa2ad6b82f8f3bc0e1f96163bdaab811e9fa9c0a4fe4830e251e35"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  on_macos do
    depends_on "llama.cpp"
  end

  pypi_packages exclude_packages: "rpds-py"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "TinyLlama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end