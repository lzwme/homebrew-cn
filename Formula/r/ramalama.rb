class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/d1/83/4b68ba62a0008283e714cb5039ec352b257c97c8e7e51f325f26844a0848/ramalama-0.11.1.tar.gz"
  sha256 "61145f53d576d5bf215d84ebe9d35f55e1df3f96f71d15557ef7139624cab8fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb56083e198410ec149adef7a6b12fcb3264689c7f37117e80b33c70a63cac59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb56083e198410ec149adef7a6b12fcb3264689c7f37117e80b33c70a63cac59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb56083e198410ec149adef7a6b12fcb3264689c7f37117e80b33c70a63cac59"
    sha256 cellar: :any_skip_relocation, sonoma:        "79b4383010c59c8811b89116a1cc1939c4e8fb40f2f37da8c1e8bc0aa6c8f185"
    sha256 cellar: :any_skip_relocation, ventura:       "79b4383010c59c8811b89116a1cc1939c4e8fb40f2f37da8c1e8bc0aa6c8f185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c441e9bd149e10bfc90f1a784790b7ffc5ca52980969b4c208a97e0ed84460f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c441e9bd149e10bfc90f1a784790b7ffc5ca52980969b4c208a97e0ed84460f9"
  end

  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end