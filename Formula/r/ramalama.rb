class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackages64913b33c028d0ea097c68ed0aef748fdf6101debb7427ef425f6e3f141e823cramalama-0.6.4.tar.gz"
  sha256 "0b02ad223d9156623366fb91b2166551ddbfd453ad19369439730203d9a69c70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30517217e6d5e2ab75e67d0f7f96704e3ec61fc981ecb826cbaac4fed5ed7caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30517217e6d5e2ab75e67d0f7f96704e3ec61fc981ecb826cbaac4fed5ed7caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30517217e6d5e2ab75e67d0f7f96704e3ec61fc981ecb826cbaac4fed5ed7caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c879451b402d80522c9d7b363ca7e5ca7b14cd48b8609f2ae8bcf574c324cd"
    sha256 cellar: :any_skip_relocation, ventura:       "26c879451b402d80522c9d7b363ca7e5ca7b14cd48b8609f2ae8bcf574c324cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0235aa2c624770554f7694d0670c92ed4e7ace468cfaf41d7dea56555aa8e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "484f4ddfdcb04c54531daf47f8712faaa24a776f57ae9725218341565ddb7621"
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