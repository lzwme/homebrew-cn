class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/94/c0/96857354765e9024825b7ac29b8c81b12e9dfe310f9ddc3786cd0f0d07b5/Nuitka-2.8.1.tar.gz"
  sha256 "456fd55c25292252f2dfb26da2c1ee0c0dbeb00106669979b8a2a1f3ae653cb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed3af64b8118c6493cb2853f888c15526b1b5115ec5fd186b396a75117bbb195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b713a9a0c40945d6ebefeaed645604e0da517b425bab2a5316784bd8e5e93a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf7acd731074e11d5b1115a151529fd58a436108288cd8a2f900b59f71421fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c1a15a05c6d56fa9672b4a320b35d521b0a2c2ca54d14a914fd50697a0b04d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6f41b0af8780c13be0850d9aa6f13ad5b47491e19ce77083bbdf0ecb7f75e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11cd541a240ebb0bcc90608c82c304ebf0fb8bc8c6e56738c73f9543dd77e65"
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