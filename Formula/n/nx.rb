class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.1.tgz"
  sha256 "e962fc22dd8ba466f1fb7cf593ba0b7207309c951d41504695c4774b0d92d6ea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76f35a628f89958227891389dd3f181f6d5265931d3f59eb3ec9b34b79d7f47e"
    sha256 cellar: :any,                 arm64_sonoma:  "76f35a628f89958227891389dd3f181f6d5265931d3f59eb3ec9b34b79d7f47e"
    sha256 cellar: :any,                 arm64_ventura: "76f35a628f89958227891389dd3f181f6d5265931d3f59eb3ec9b34b79d7f47e"
    sha256 cellar: :any,                 sonoma:        "5bc751640fe0bd3a5a6c717cc863e220c268f5fa5910a328ba6cc8ffd450ca6c"
    sha256 cellar: :any,                 ventura:       "5bc751640fe0bd3a5a6c717cc863e220c268f5fa5910a328ba6cc8ffd450ca6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a7affad3b8d61b63dfc52a073e45f5935f766a39bccd146cc38dacbb8ecdabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9e27425bf73085aecb040bf205eb9126d57f40d02e7594d543d40f68d5d60a"
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