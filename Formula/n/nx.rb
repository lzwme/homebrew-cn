class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.11.tgz"
  sha256 "a802f3987bc449770d2ed9f591e92638aeb8de3fddf10fa370b7fbacfb7e636a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bef74887d4bb7e7d42d663ab4f60cc3e8165bce36690ac0d923f82328bc11d4"
    sha256 cellar: :any,                 arm64_sonoma:  "0bef74887d4bb7e7d42d663ab4f60cc3e8165bce36690ac0d923f82328bc11d4"
    sha256 cellar: :any,                 arm64_ventura: "0bef74887d4bb7e7d42d663ab4f60cc3e8165bce36690ac0d923f82328bc11d4"
    sha256 cellar: :any,                 sonoma:        "f5cf8488388688068a6e6a0074415022ef6b9fcab19dfbc3c091666c578e9f24"
    sha256 cellar: :any,                 ventura:       "f5cf8488388688068a6e6a0074415022ef6b9fcab19dfbc3c091666c578e9f24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16c316b3a91e6df8115228f48a407dfb50ba66572f0faec0bc26f9f3d1882ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c8f7c88a4c9235b4d41a6a8745274c3deec8411da052d3d74610595411c0b8"
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