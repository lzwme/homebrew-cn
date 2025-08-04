class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.31.1.tgz"
  sha256 "993f8d03e9fb93f266f780871ce482e7a36c0f65096f8057de2236ca0f36f84e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4308abf4edcde46f48b922477ea3d5599f59616454126497f6a9a5c0e1015ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4308abf4edcde46f48b922477ea3d5599f59616454126497f6a9a5c0e1015ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4308abf4edcde46f48b922477ea3d5599f59616454126497f6a9a5c0e1015ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "319a3c15487672fedcb23ae93c02646c2f5c8fbf4ac3ebdc5bf16ecb7663d151"
    sha256 cellar: :any_skip_relocation, ventura:       "319a3c15487672fedcb23ae93c02646c2f5c8fbf4ac3ebdc5bf16ecb7663d151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4308abf4edcde46f48b922477ea3d5599f59616454126497f6a9a5c0e1015ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4308abf4edcde46f48b922477ea3d5599f59616454126497f6a9a5c0e1015ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end