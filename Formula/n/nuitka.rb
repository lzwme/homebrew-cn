class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/d6/40/7fd16fffa8bbf78f9f9b1abe75ac123e3cc46740c6142c4db4e29b32ce4a/Nuitka-2.7.3.tar.gz"
  sha256 "bd3dd12c5f0dfec0208f88c14ef3bbfc4ba3495eafc62c31b4e1f71171536e47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9101af7e7d4315fc19e14defa47cadf4ec3eef0e06ad8181fc338889f07a762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b176e2ee40502b65927f6bab5b311e450de8ef46d37a17f5b9d2c740e1ebba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3c65c4da2d1753a1aa46db7113c6c11833b109d43acd5a53f57a9bcf28f754c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2176b444bc74710835ab81c2d3f702adab1da1e86df1c7aa5a8bbd7466dd927a"
    sha256 cellar: :any_skip_relocation, ventura:       "ce3e1d74d3c1c6c329369a8147712f541849168d9f6523601e188034eb594d39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54fd352811b3c1d2e736ff6086dae6943b184ea0f3347305a13ba118a6688b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7f0f5991a82dba4a3a45ff8a2836fc18e88cc3ff3597cc6350c5816e1c6202"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end