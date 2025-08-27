class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/c0/73/8735d3464a0bf5cc074772514205e741dfa8d3f1f5fd765a3686ce7c8caa/Nuitka-2.7.13.tar.gz"
  sha256 "941c6ee2321fea1d297b29669228939200640110be2a8b0bdedfcf6c3bc816b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09e2aef93e23eec67bb6459b57c164d2bde29021f0326c1342ffa712245b85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6012e73b6d758cbe2cb446e4dc9731dffd348d7b08d53e6f8fb1f7cc4810a89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9b88cfdc01143cf3439b2b268470e0ee05e4a5a38713c66fddfe0de9d018790"
    sha256 cellar: :any_skip_relocation, sonoma:        "576f82bec6bdb8c98410cc569880fd27831faef4fcd9e0c220ff77addbc5769e"
    sha256 cellar: :any_skip_relocation, ventura:       "a3a234f8487f76692a87ae59cdbcf42efedce8ceda8b2c9659fc746bcc0189ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3575d3ddec4816b3e83550ed1f98a8e35c07d6f167885b9f6014ac57305ecad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6935e415f20dbfbbd747d9909312ccab7eee49b289afc78f5357fe2612112986"
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
    url "https://files.pythonhosted.org/packages/09/1b/c20b2ef1d987627765dcd5bf1dadb8ef6564f00a87972635099bb76b7a05/zstandard-0.24.0.tar.gz"
    sha256 "fe3198b81c00032326342d973e526803f183f97aa9e9a98e3f897ebafe21178f"
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