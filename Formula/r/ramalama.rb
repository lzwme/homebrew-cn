class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackageseef022c24f3e42a90ccff3bc7ce8e9934e9dfa73d57dd02c955e6308d2c08248ramalama-0.6.1.tar.gz"
  sha256 "ea5a58d56f1588c275dcc19baa47e6a2cd167d9349e853a8d449af6c27b22e6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67aa8b9f4e99b8ba7a66a015c20852deaca6ed43ce00476faf49ce45a991a97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67aa8b9f4e99b8ba7a66a015c20852deaca6ed43ce00476faf49ce45a991a97e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67aa8b9f4e99b8ba7a66a015c20852deaca6ed43ce00476faf49ce45a991a97e"
    sha256 cellar: :any_skip_relocation, sonoma:        "040a81abcba18d77d06fafa9060ce576910088d9987ef39e7a5c8f6f9e5497f3"
    sha256 cellar: :any_skip_relocation, ventura:       "040a81abcba18d77d06fafa9060ce576910088d9987ef39e7a5c8f6f9e5497f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ed70afbcfe838aabc24826f1257921e3976a00fc0612ff81849ecaff03a141"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0cbe6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
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