class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.7.tgz"
  sha256 "a432954bd0dac270d7748f86505a0024f6ccb9c2eb066f686c698024c4f743a0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2715e295a7c4006c1812372d7d14fbe53f4104a09ac29433ab55ba37f10b9b0"
    sha256 cellar: :any,                 arm64_sequoia: "9eaafdc48ed5504c356e852ba9071aabd986d006d4951438d3ec84801d87025a"
    sha256 cellar: :any,                 arm64_sonoma:  "9eaafdc48ed5504c356e852ba9071aabd986d006d4951438d3ec84801d87025a"
    sha256 cellar: :any,                 sonoma:        "4d4cfe177b1aa8dc88d62cc6f8ad0ebc6d91776eb0521608f8ab9f116546a5ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c6dbee4df7cb8d985b073e5b0006d885bab2a9371e8a6373b452b48d33a1a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb3aae967b111b2a511754dde01b1a113485a0770d9ab9932571544feb968ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end