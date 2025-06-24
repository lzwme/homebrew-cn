class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages188c542586bc878db32826821fc5fa8b906d7bc949d5b6fd4b8e72dac8d82385ramalama-0.9.3.tar.gz"
  sha256 "c2445287bb13ea0271a6686f66b8a1ce27e7232975b29acb3471109f0cac72af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1069dbb563a4b2060824fc1c3f1bfedaa08c03df82fb0e4689556dd494790cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1069dbb563a4b2060824fc1c3f1bfedaa08c03df82fb0e4689556dd494790cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1069dbb563a4b2060824fc1c3f1bfedaa08c03df82fb0e4689556dd494790cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "433b09bedd51bed5d5e9baa924ea3fc6cdc792cd868ddb31bb0486882e48fbd4"
    sha256 cellar: :any_skip_relocation, ventura:       "433b09bedd51bed5d5e9baa924ea3fc6cdc792cd868ddb31bb0486882e48fbd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd363b1567699e5a3529733a123b75463cb69613e46ab44b7f3b1a9095c44f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd363b1567699e5a3529733a123b75463cb69613e46ab44b7f3b1a9095c44f34"
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