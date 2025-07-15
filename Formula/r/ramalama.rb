class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/ee/e5/2f586710c3d8bf04585d5f6b0cfe7dc41b194fbda41f4ede77d05912bd40/ramalama-0.11.0.tar.gz"
  sha256 "a215e3c5b4c6cb1146c156ae5032978b34bebf2ac986035211ca9ca17a16a5aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6772070e945eb1ecebbe18033a98d6c684d5a9486fcc6d323ae8ae0db3836c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6772070e945eb1ecebbe18033a98d6c684d5a9486fcc6d323ae8ae0db3836c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6772070e945eb1ecebbe18033a98d6c684d5a9486fcc6d323ae8ae0db3836c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "39ebd86b1d9c6182da1ceae49e4fa1fccd9ab732fc82f4c089358ee540e33023"
    sha256 cellar: :any_skip_relocation, ventura:       "39ebd86b1d9c6182da1ceae49e4fa1fccd9ab732fc82f4c089358ee540e33023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d02660e5015547e13642325a6765501ba2609c621f94c567a4b808e7cf54d7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02660e5015547e13642325a6765501ba2609c621f94c567a4b808e7cf54d7dc"
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