class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/6f/87/f20ffda1b6dc04361fa95390f4d47d974ee194e6e1e7688f13d324f3d89b/Nuitka-2.8.4.tar.gz"
  sha256 "06b020ef33be97194f888dcfcd4c69c8452ceb61b31c7622e610d5156eb7923d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faba78fa9c6e612878cd65bc7f29a1e5dee7d764c81282f4b9e8120258b7bdf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f752c1c671e08ab79fcf75144316bc7038dc9983ad4aed5d5640439de809f4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c4671ffcbbe3edde17926099be676ecd85f433dcf91f28d0a93f115fce1cca"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e61f90bd45d55c3b070bebb762754c8aa06edd791c0dd4d25c1974e9a155438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9385614d88d4efc9364e9a05fdfa446e14b2f58ef47b9454c40bef6cbfe23bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa8ffd7296a8f5ff44f89e4ad915f36312ef4c693e6705c89e49a2e39ab75d17"
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