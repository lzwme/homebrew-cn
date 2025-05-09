class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/18/f7/f1d87901ab90be0bc1dd96d9f899a07f626f5f2bebe3b09e475fdc4b7fdb/Nuitka-2.7.1.tar.gz"
  sha256 "1e7ff9208f8d8262302a6eee05d299650f30813dbecb4501d365a712c3169209"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72cb5e538d3db3c7742a6155606f13350c4605b89e1962c49e90864622f4451e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b24a4aba716029a2e0ea32cab4c9b6d1aeeba8e0a5363064e477b9862c00ed73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7651b076627740a40ca57fc53ee6f61ec69c38b20a8f554ec86d9cae77bb0a3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffd348002bd119192b90c706aa459975854fdae9ce9f93d60d49645fcce0655b"
    sha256 cellar: :any_skip_relocation, ventura:       "2932404b16d1ca103de4b8ae9b225c509804b732a7186485ade31a1a59fdaacf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfb03a6085a4e87d2d32dcea1da2469ee0a06b7a6397a03af2eb47c882201a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddd2eacca381fe1130c455c7fc1937c4ce7f38263c62651b8a84c2cac2ccac1"
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