class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.5.1.tgz"
  sha256 "a70ffd9d90a4e2420b7f27d58dc6e7f28c44461eb71ea34a9d2011398eba91a6"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c22532662762a4faed276440234962ca70913dc8d7af8f352be327a337790ad"
    sha256 cellar: :any,                 arm64_sonoma:  "2c22532662762a4faed276440234962ca70913dc8d7af8f352be327a337790ad"
    sha256 cellar: :any,                 arm64_ventura: "2c22532662762a4faed276440234962ca70913dc8d7af8f352be327a337790ad"
    sha256 cellar: :any,                 sonoma:        "1f00bf0dee9bf0ae9984c6cc372db5d7a0b59a0eec47dd1d4ce8c0a1b1b6ff5d"
    sha256 cellar: :any,                 ventura:       "1f00bf0dee9bf0ae9984c6cc372db5d7a0b59a0eec47dd1d4ce8c0a1b1b6ff5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6b654be1de0f3382ac5185c395bc02f5df24adde14d17d54ac197a2d6c8fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99bae69bfc00b2f919682e813231050c354b98c395526f164c1070d2c4491f3"
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