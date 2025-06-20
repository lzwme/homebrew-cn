class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/07/23/01d9537320d170abff79d9f61bd1e9500b464a503433c0fa0a76375f3fd2/Nuitka-2.7.10.tar.gz"
  sha256 "c510c44027bcd9890deb00586ea87b00dc787addace0722095f041b1414395fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1d316bace4bfc0626895c557a61d504aa451cb34a3402a41c0d0d626122e44e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c866b905e11139226c9aa72499c1220d8517778a2199dae861506ec19d3e99be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ca5a7d27770ac20d661b7b95921451b4007751d6519fcbe076be6057af495bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9387789345a7519c30303107a93ac74fe5fb9352998a2bde5f4781a74e38d4e"
    sha256 cellar: :any_skip_relocation, ventura:       "3caa9ddbf313d86e80e79e5ed66f62bf1ee8323d70f21837ac9709a1f5ea5460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "542e627e54e47baef9d9eac2a16bb510b8e3a04c2018ebafb8fb76235ff2035e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92bf282607e64d465f30b1fe44bc2cac6d0b834ddfc3369cfe60d8a66774cb4"
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