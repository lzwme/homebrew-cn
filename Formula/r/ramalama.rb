class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/b8/3e/8cd38c3a0014d47a5a4bcb8e80e0a730e3cd1cbfd900b8af3a3c65ad37ad/ramalama-0.11.2.tar.gz"
  sha256 "d9a18981903928ca4ee4ad663b94a11a1c17ff5eb0c7bb69d0b0466dae5b3ed9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "393a14fafd3b260939b781d03848b0d8b3b1d686d8376c7bcbb0d9a3b4fc03cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393a14fafd3b260939b781d03848b0d8b3b1d686d8376c7bcbb0d9a3b4fc03cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "393a14fafd3b260939b781d03848b0d8b3b1d686d8376c7bcbb0d9a3b4fc03cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1778b3c96e508680c0c2b0bea4cb75eb8f51b5fc55acdebcfb6d2dcc08dc973"
    sha256 cellar: :any_skip_relocation, ventura:       "b1778b3c96e508680c0c2b0bea4cb75eb8f51b5fc55acdebcfb6d2dcc08dc973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d54626a27d0b49e5dc53bd0896c98020d1f79c0e6262da75466bbe1375fd2c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d54626a27d0b49e5dc53bd0896c98020d1f79c0e6262da75466bbe1375fd2c94"
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