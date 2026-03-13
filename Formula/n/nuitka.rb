class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/f8/40/f73e578922084f9e465b30abdb9963aadcc087b5a9399033472d9ef641ab/nuitka-4.0.5.tar.gz"
  sha256 "45e7d90266e76fe64eeb8d196c17666d7cd7cffbf68d6a24f233c3c03b6feaa8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92979853818f218052f3a17d1ceed99ce8fa8fe696ce5ac3c74745bf07fa0d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c5377b959419b49a64d707aca4fc241fb4aed50d6bc6bd4863167236b093d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f210135299a233b78e8ddf5e2b10031578220fe1fcfd212d27696aaa52a646e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "da06900cb9d813d0e494e97e76c7387298a32e2c56618399e263c26bccd8c6b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c29720cf610b3974974b252e49e7ccd496528d9f63b0a695518618eebddcb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f31906f17bd02c389d6d5a129745741e48a17f5c37ab8e0792619add636981"
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