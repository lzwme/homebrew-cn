class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages7728c7a0f39b4cd57cd445c4f2cde35334d177ee09c0fa29242adf27b64d6ec2ramalama-0.7.4.tar.gz"
  sha256 "b002b141dc06b5c8388c49ead60dc10fbae596ce5211d9d4a08aeeb82915956d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b6110a23762cdc082bf80437a10f6b0438b2107ced196d468a5c11527edb2ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6110a23762cdc082bf80437a10f6b0438b2107ced196d468a5c11527edb2ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b6110a23762cdc082bf80437a10f6b0438b2107ced196d468a5c11527edb2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "93857e0184c8a91f16f89d63ea5d56b8fcb9a86914eed8a74a905a3dc7b98533"
    sha256 cellar: :any_skip_relocation, ventura:       "93857e0184c8a91f16f89d63ea5d56b8fcb9a86914eed8a74a905a3dc7b98533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "662422d59147628f327de026d2c9593b32ec115e356e6b71b9e936e8ebdefa5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "662422d59147628f327de026d2c9593b32ec115e356e6b71b9e936e8ebdefa5f"
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
    assert_match "invalidllm was not found", shell_output("#{bin}ramalama run invalidllm 2>&1", 1)

    system bin"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}ramalama version")
  end
end