class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.3.1.tgz"
  sha256 "94279a651663fc7540bc29b93625636e886868bbb197eb0ff4067946553a1522"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a4be5b97265b8c4f24073a771def5a5511432551b39c4991b2b0fc84eead0cb"
    sha256 cellar: :any,                 arm64_sequoia: "7eaa66ecf05c98a1be36c337bd3548c64c9759221884a9adf336bc278b39183f"
    sha256 cellar: :any,                 arm64_sonoma:  "7eaa66ecf05c98a1be36c337bd3548c64c9759221884a9adf336bc278b39183f"
    sha256 cellar: :any,                 sonoma:        "9568d2a7d2349b38465ed5851e0c8df399dd6ecb1e19996d4131a9a4bfdd99d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22c247972602ead673cbb808fe628210bb4c401e6e26866cf643489eede471f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6d459c7df578ee4be0f9d1bf2ce68b9731ddceea4e2a8a732a0ee264bd5e874"
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