class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/e5/d6/477dc84457fc07885f5fd020da4920e8a2787b2c04563ad444ac98f7d3eb/nuitka-4.0.tar.gz"
  sha256 "0f404f292c3c2cc808d186d05a6d06a4b0aeca93f299cdfd5e33ddbcd19ab560"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8c24137980d52770ce0f516d45a57b001c76a2a6b8c41bfbdb8884f2246020f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2202b0beb56a8abf38f79e9334cae2bce867cff2ea548d2440136de9205f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da113cb3da3e9cf4c04dffea926084b4175c3d0bbdc23cbfa538764a98c3169b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcb41f6787603063242f86689d509ea9ec91625a36dbeeab6032ae384e28a34d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f3313ffafb4758065319f004830eabe056824f7b2434a7b2eda448fc933642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6802e1449f81d37b0e243824e7543a5b5f15c74fb7753c206587bb7138cf6c24"
  end

  depends_on "ccache"
  depends_on "python@3.13" # planning to support Python 3.14, https://github.com/Nuitka/Nuitka/issues/3630

  on_linux do
    depends_on "patchelf"
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