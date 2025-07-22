class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.2.tgz"
  sha256 "92498022c7d2554b53d6ce2c5c0d7bfea475dde0274db46c50bf2c2bec06e3ba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d17b4c6eb75fad9f76185dd005dfd355fff15050bc13d3ab9dfa333fb81cc69c"
    sha256 cellar: :any,                 arm64_sonoma:  "d17b4c6eb75fad9f76185dd005dfd355fff15050bc13d3ab9dfa333fb81cc69c"
    sha256 cellar: :any,                 arm64_ventura: "d17b4c6eb75fad9f76185dd005dfd355fff15050bc13d3ab9dfa333fb81cc69c"
    sha256 cellar: :any,                 sonoma:        "b3befe4f89af2210b27fa7968f5f445f5dc732e95072b91812ba4ee2ae481923"
    sha256 cellar: :any,                 ventura:       "b3befe4f89af2210b27fa7968f5f445f5dc732e95072b91812ba4ee2ae481923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a980860107e211bc7aee0ed7a5c4123c57c69864c097778166bc4812ae6b15ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd803617d6637b3d8539a9df44270677ef493036b2d2bec432eac0cc24c22bc"
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