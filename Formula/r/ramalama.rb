class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://ramalama.ai"
  url "https://files.pythonhosted.org/packages/10/c6/2487a19773ad71e05e476c3e6df6b78e8ab056270b5b7876a98602f1025b/ramalama-0.25.0.tar.gz"
  sha256 "54daf1cde410347bd0cc7a8f1b8a036a19e8f7d63367d9bc63be8bf4ccc0084b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "941f6c7c4eafcae55b6936414b114b55cd5cf01d5d23e54060ab493f098f7a56"
    sha256 cellar: :any, arm64_tahoe:       "eb33ebd589e91493b58dcbde23f8537b8cf34160b9bcd9e2372613fa96ca1521"
    sha256 cellar: :any, arm64_sequoia:     "528d9922af7d277043276bdd1bf8c4fe0107b7f97ba75aace01829ecdc641fe0"
    sha256 cellar: :any, arm64_linux:       "336e92f0acfd8c3d72c4ff71b342c708cf4e8bcf1c0d991cf2eb3351d506bdee"
    sha256 cellar: :any, x86_64_linux:      "cb7e35e968db1fba34e5fc914a93b21288c706ebfc13f8ff8e2b1fa41d1af605"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  on_macos do
    depends_on "llama.cpp"
  end

  pypi_packages exclude_packages: "rpds-py"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
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