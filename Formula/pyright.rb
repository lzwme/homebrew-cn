require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.319.tgz"
  sha256 "ba5a2d0f3e134d3b86e9138f8aec2773a44445946a6533ea7e8d36acd80882c7"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82d84d1c3aaf298cc0ac4e3f80435383313fa34c6c0be94034d4bf70d98d36bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82d84d1c3aaf298cc0ac4e3f80435383313fa34c6c0be94034d4bf70d98d36bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82d84d1c3aaf298cc0ac4e3f80435383313fa34c6c0be94034d4bf70d98d36bc"
    sha256 cellar: :any_skip_relocation, ventura:        "8782fd556c10538021d45940be55acce8924f4817b587c53cb49e39ad57c3d1d"
    sha256 cellar: :any_skip_relocation, monterey:       "8782fd556c10538021d45940be55acce8924f4817b587c53cb49e39ad57c3d1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8782fd556c10538021d45940be55acce8924f4817b587c53cb49e39ad57c3d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "311f366ae3a6527217d78da2ce59888dc5bd493435172415d95bbcb30946990c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end