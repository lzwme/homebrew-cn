class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages02e64e35a28781b912603aa3f3c4486572af3b3e68d79f2b76243564c7f1d94framalama-0.6.3.tar.gz"
  sha256 "daaa26c7e915bbd6788e70629c27d7e628fded62c534d95270438e724ba4ed05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e94e70819f18c391fdc15d9ef8d1bc94488b4f14ef67846a558e5414e36ca47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e94e70819f18c391fdc15d9ef8d1bc94488b4f14ef67846a558e5414e36ca47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e94e70819f18c391fdc15d9ef8d1bc94488b4f14ef67846a558e5414e36ca47"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef6f7ebf196f859296b543a65549cbeea908577f913741c18dc162dce53cdeb3"
    sha256 cellar: :any_skip_relocation, ventura:       "ef6f7ebf196f859296b543a65549cbeea908577f913741c18dc162dce53cdeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7f92bbbe703a83e09ab0ea7e4c06d3ee59d66315e1199b14409abe25f19af2"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackageseebe29abccb5d9f61a92886a2fba2ac22bf74326b5c4f55d36d0a56094630589argcomplete-3.6.0.tar.gz"
    sha256 "2e4e42ec0ba2fff54b0d244d0b1623e86057673e57bafe72dda59c64bd5dee8b"
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