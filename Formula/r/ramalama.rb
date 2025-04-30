class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages6cfac251af56dfa25d45c07ebbd597a9986c804edbc026e05a7c25621d89b8ceramalama-0.8.1.tar.gz"
  sha256 "4e1a91989c95252b1c009c6e58e7d18165b87c190f1b375870e6f4a56e70e14c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d307f042288498f5bc81c1e895a298917e573c8363e07a3fb3344dda9ad91408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d307f042288498f5bc81c1e895a298917e573c8363e07a3fb3344dda9ad91408"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d307f042288498f5bc81c1e895a298917e573c8363e07a3fb3344dda9ad91408"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b2d2b67d0333f7df695f2e820db314e7b0a2b662d05eb71ab60a0b7c0361c6"
    sha256 cellar: :any_skip_relocation, ventura:       "89b2d2b67d0333f7df695f2e820db314e7b0a2b662d05eb71ab60a0b7c0361c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331cfd8b27333448a8f36806def92e84504a655ef987d2ec7b459fe85c3f597c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331cfd8b27333448a8f36806def92e84504a655ef987d2ec7b459fe85c3f597c"
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