class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages9bd3aa3dc4caf303c93b4c32a25f77e2fc05e18e8bcc76df6af61c1584727932ramalama-0.9.0.tar.gz"
  sha256 "a973312168f6edbc0997b3b93c950beddbc03cd6c43c0d24f6538a1920263ed3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15fc72a46d8a9211648d780a38ba64989c90dc4b55479aabfc95598c9a48d30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15fc72a46d8a9211648d780a38ba64989c90dc4b55479aabfc95598c9a48d30c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15fc72a46d8a9211648d780a38ba64989c90dc4b55479aabfc95598c9a48d30c"
    sha256 cellar: :any_skip_relocation, sonoma:        "34685c207b9105825ba20a873864db5d164af8fe08d86fa160a2c7fd3d197671"
    sha256 cellar: :any_skip_relocation, ventura:       "34685c207b9105825ba20a873864db5d164af8fe08d86fa160a2c7fd3d197671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68e157e6fc0e68a811656c287d6b9a6b19bbd79bd69cd9431f8610b93b951cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e157e6fc0e68a811656c287d6b9a6b19bbd79bd69cd9431f8610b93b951cf0"
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
    assert_match "invalidllm:latest was not found", shell_output("#{bin}ramalama run invalidllm 2>&1", 1)

    system bin"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}ramalama version")
  end
end