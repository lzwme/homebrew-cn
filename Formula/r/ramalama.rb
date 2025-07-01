class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackagese8e469e424a852e0007d18538a800b8b3864d62287f81fe9c0fb1fa839fc8b5cramalama-0.10.0.tar.gz"
  sha256 "c4be094a50541f647c9563e3bd1f6b786cb8683f938a84a39b1a63c495dbb219"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b48e46c0a606fbab78ccb42a6a6e33db481db176e24423b37d03740f5c6e478"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b48e46c0a606fbab78ccb42a6a6e33db481db176e24423b37d03740f5c6e478"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b48e46c0a606fbab78ccb42a6a6e33db481db176e24423b37d03740f5c6e478"
    sha256 cellar: :any_skip_relocation, sonoma:        "15b3a2cc2372cb0a49f7bbf86a4c93f30c1c2cf7e9711338e876b4b9cc285e3a"
    sha256 cellar: :any_skip_relocation, ventura:       "15b3a2cc2372cb0a49f7bbf86a4c93f30c1c2cf7e9711338e876b4b9cc285e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "679af2a552cbcfa57865b956f46eb2728510cf9232ab1aaad44ac92f7e0908e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679af2a552cbcfa57865b956f46eb2728510cf9232ab1aaad44ac92f7e0908e2"
  end

  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages160f861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}ramalama version")
  end
end