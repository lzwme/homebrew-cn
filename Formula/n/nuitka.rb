class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/a6/b8/5c58a2c4d66631ec12eb641c08b7a31116d972c4ccbb0a340a047db51238/nuitka-2.8.10.tar.gz"
  sha256 "03e4d0756d8a11cb2627da3a2d9b518c802d031bf4f2c629e0a7b8c773497452"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea9c606c6555d2129825c4d36c52d3c80104d809659880ae081bb5baace3a79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4c0bf2a6bb41db0922d72c028138124d1d63e8e22153dea6450d05a607c532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629c3c833ebbb12f069575cb1f7f0f283733c71fdd320c9fb28db26e7793eb13"
    sha256 cellar: :any_skip_relocation, sonoma:        "bacdc8c0467064d9d034e5eb2d3eb5b3e06809eb25d98ffdaa54a1c111fdbccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "811e880a8a6120a9f97f72da01bc5afb86c7368c53840db267955042dfa171a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8112e8773e1f44cf4be6a1781d3a43bbd2a83e5cb81755840f5ac9d17e0ccdc"
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