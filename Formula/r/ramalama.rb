class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages6557bb1f0b25025cac69ea73d5336f71f9eded0d262cbf2f766501a990d8f062ramalama-0.9.1.tar.gz"
  sha256 "61fce17a46ca6d7dc04c4fbceb6a12853fece3a13b7b171f7cdff19ceb989a12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fb6b4ec2e53e07a84e6a439997cbca55b2bf77180c971342894b59b04f307e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fb6b4ec2e53e07a84e6a439997cbca55b2bf77180c971342894b59b04f307e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fb6b4ec2e53e07a84e6a439997cbca55b2bf77180c971342894b59b04f307e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cf68c48d3513dacdb74f08d2116544737d762f7c2636aa004fe23302ea817c1"
    sha256 cellar: :any_skip_relocation, ventura:       "1cf68c48d3513dacdb74f08d2116544737d762f7c2636aa004fe23302ea817c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f6665be7f1594113ab007b3a9ab0c7545cfd6382f34b38a5b0b6e37f37451d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f6665be7f1594113ab007b3a9ab0c7545cfd6382f34b38a5b0b6e37f37451d"
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