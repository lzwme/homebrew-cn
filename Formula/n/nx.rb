class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.9.tgz"
  sha256 "71ebacbb529760debb928abd45a1015133a88acf9b4dbe94d0ff9b494dc7a2ad"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4fc9acef6c80c8a372da9b36899f2e074aecafa8c491d412998f98f20decfbd6"
    sha256 cellar: :any,                 arm64_sonoma:  "4fc9acef6c80c8a372da9b36899f2e074aecafa8c491d412998f98f20decfbd6"
    sha256 cellar: :any,                 arm64_ventura: "4fc9acef6c80c8a372da9b36899f2e074aecafa8c491d412998f98f20decfbd6"
    sha256 cellar: :any,                 sonoma:        "8ff29913011a94932744af8dca1dad6cdec33b44042d71c4ed5e0646c41caa18"
    sha256 cellar: :any,                 ventura:       "8ff29913011a94932744af8dca1dad6cdec33b44042d71c4ed5e0646c41caa18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3402d4e9a32c7654752623f796394a5c9189b316be18999d0a26cd401a427c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bae7c9bf8eea753181f1cecdf50eed7172b060b562f29acab6faf2da03ff2a2"
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