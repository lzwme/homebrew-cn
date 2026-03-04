class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/4c/b6/3f66e08f0b84a0b64582de37b0658965657a2ebfa2df91c66429dabfbdd0/nuitka-4.0.2.tar.gz"
  sha256 "86f6e8c4caeb2fd727620a971c0628b2cfee908a9ba78f4d733a4192b54eb9ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f1fe6b4e3568e762756b5f05fe1c17124b0dfb0ea24db17e68815d121c7e68c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0636bb58f62f989353281110a13dc52a3ce7bb93dad36d98f7f3d78aea3b7778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a3e961026d00fe0b58593d7efa91c37e574115fdb734ef75f7c5f99f60e0b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ddf8f6007c148d0e2acecfcfdf81fc09bfc5c0f8d003519c173bf9dfe11a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b2138f972ce694d48aed62936299a4ca6bd0797185755fd265bd1fb68dcbc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98973503612b7c9d2502f3c40e41690d1b80fc9f0eecb04b93f6c6c5485951b"
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