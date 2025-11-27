class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/4b/c8/0a8e2e17438cfaf7596f7a30287fe0fdb5ae5718cafd19fa89f500fdb213/nuitka-2.8.8.tar.gz"
  sha256 "fd0e652ed4f1452f34eb8e25c6902b153aad00882347c2b6b7ad80fb6f02de5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82bdfa4156a6c72f127a86e1f108891f50dd25dc1464cb7fcb0831428cec04a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18389f4041bd63333aa258039361aa582619667810617952c929dd4bc8fdb555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f76ad7c78127dd11b2e18d8abe40e394171797094f4ecdde484d0189640db2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6db8f34a0c89a490909a5aebf149d3b33fdb5c84d1e0ad6c2b3f41f58afb5de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1d2d5f01cb209ffa28e2c7d710792972f779f9ff9776a87b9658d9c141951c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59b906a12de974f76f20515ad1eb03c088697793174eaaa3d22f2affb71ae00"
  end

  depends_on "ccache"
  depends_on "python@3.13" # planning to support Python 3.14, https://github.com/Nuitka/Nuitka/issues/3630

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
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
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end