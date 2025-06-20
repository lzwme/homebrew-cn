class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.2.1.tgz"
  sha256 "6b07809bf959112ad9c6764e6366a8d13bb445dc7674239381249cd2fd6901d1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ee808b274ad9c6e4d2fa86b869545f8eaca244b16556de2399f8242fcfcb39a"
    sha256 cellar: :any,                 arm64_sonoma:  "5ee808b274ad9c6e4d2fa86b869545f8eaca244b16556de2399f8242fcfcb39a"
    sha256 cellar: :any,                 arm64_ventura: "5ee808b274ad9c6e4d2fa86b869545f8eaca244b16556de2399f8242fcfcb39a"
    sha256 cellar: :any,                 sonoma:        "73bde5e8b63ba4b0e004671ba4b3b515d2411d8f77b6b75e447075a58ed06d9f"
    sha256 cellar: :any,                 ventura:       "73bde5e8b63ba4b0e004671ba4b3b515d2411d8f77b6b75e447075a58ed06d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "945da8762e3d96981d02702670a789cf0dcf348373fa18cc3a2ebb39d2f00067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28a5c7bdd42cb657036d16aa9d577a197e07d3f1eb6e5d4b803e5127b77b89f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end