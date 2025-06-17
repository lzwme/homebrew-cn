class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages7ef6176978055ffc7483e089735860870848509e4825b74d3a275935df586318ramalama-0.9.2.tar.gz"
  sha256 "f8189c287c2915083c4571158651b008a667fcb6d02b5c66a93f14745e85f4c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c509fb86607aff9d8b529666cc6e78f623261084ad8d1627d5806e12db35705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c509fb86607aff9d8b529666cc6e78f623261084ad8d1627d5806e12db35705"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c509fb86607aff9d8b529666cc6e78f623261084ad8d1627d5806e12db35705"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c51cb354a54900c230a9d7b6570e2813fb42549e9c5918082423c89594ec51a"
    sha256 cellar: :any_skip_relocation, ventura:       "4c51cb354a54900c230a9d7b6570e2813fb42549e9c5918082423c89594ec51a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209ee132e5bec74a579c642071c67a0916cec19aabfc2bd163f2c02a0c83b3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209ee132e5bec74a579c642071c67a0916cec19aabfc2bd163f2c02a0c83b3e5"
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