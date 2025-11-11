class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.0.3.tgz"
  sha256 "2084e68d1538900e51b34970bb0bb67c73ae2cbc75d13b69d5a20c40f09c5e73"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a9693cb8447191f0253cdbec298010b6f923bcba8641a9c6464d798263ad9e3"
    sha256 cellar: :any,                 arm64_sequoia: "c4b0b23ce65c8bbe870a0db713376b49606c5c3fb615fde8769a24bd5fab75c3"
    sha256 cellar: :any,                 arm64_sonoma:  "c4b0b23ce65c8bbe870a0db713376b49606c5c3fb615fde8769a24bd5fab75c3"
    sha256 cellar: :any,                 sonoma:        "f88378bac0e0e60bf8991e029a47bd902c5d3140a4d6d504dbd926050fd2f183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1ce0c9508252579b38b18c9ea1abaffd37ff97cb4aaba489757a0febd7480f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb04b250cb937475f643ddcebf2b37c49bf29ef29fa8a34021ef6f34119a03b8"
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