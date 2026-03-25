class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/ed/0e/2537066db2458843e4a1edfc524409069ad58a456fc4b312b18b1d327431/nuitka-4.0.7.tar.gz"
  sha256 "26543bfed6009a466ae8608bdc643add81a497e8662e4aaf157cd00aa7fd5b9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "446a6c056e9ee1dbe150a3baecebb7f56710424006a6e45d8ddec6430ae6ea4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8cb422d3ac4735a57b129e3e2ffd9d0d5e48da629f866b327e1b6cb377717f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f9b2e79a92e4fffb9f1d36f6b7af766ad8c9863249dc285b7448db9845111db"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e7a727c8d2d516df1d443b6bc3c29b0f988edc2131e58a1e1ffd277ae67198d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8821e787630c9f5d2eb241712640f09b3191ccdb7662daeaee2f32ec64f5766f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b28b3abf449981e79bafe755d6dbe63ae24574ec255f88c37957c240597f80"
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