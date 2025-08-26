class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/85/1d/c12704e04e610e8a277c89858474db7790290f3b009c6615467a589405d5/ramalama-0.12.0.tar.gz"
  sha256 "a19c4ba3dd57848a1000ee9eed8798992b88883335a1d47c030b831ea9f8dab9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5bc24164e3be625e6c502044848b355a0885ae7f63af4ac1d33f1eb13aaa253e"
  end

  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources

    # Build an `:all` bottle by replacing comments
    site_packages = libexec/Language::Python.site_packages("python3")
    inreplace site_packages/"argcomplete-#{resource("argcomplete").version}.dist-info/METADATA",
              "/opt/homebrew/bin/bash",
              "$HOMEBREW_PREFIX/bin/bash"
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