class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/85/1d/c12704e04e610e8a277c89858474db7790290f3b009c6615467a589405d5/ramalama-0.12.0.tar.gz"
  sha256 "a19c4ba3dd57848a1000ee9eed8798992b88883335a1d47c030b831ea9f8dab9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2769a2457c34d1fa2cc18bf95bae7acda3346b2735771e0ab4cf09a402248b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2769a2457c34d1fa2cc18bf95bae7acda3346b2735771e0ab4cf09a402248b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef2769a2457c34d1fa2cc18bf95bae7acda3346b2735771e0ab4cf09a402248b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4671c8b477f5b6694c59e3083401a136840dd970a4544bb93567c9dccb0cfc77"
    sha256 cellar: :any_skip_relocation, ventura:       "4671c8b477f5b6694c59e3083401a136840dd970a4544bb93567c9dccb0cfc77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4671c8b477f5b6694c59e3083401a136840dd970a4544bb93567c9dccb0cfc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4671c8b477f5b6694c59e3083401a136840dd970a4544bb93567c9dccb0cfc77"
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