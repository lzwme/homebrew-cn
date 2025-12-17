class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.2.6.tgz"
  sha256 "91b3b0f760ca1b3b8f4976c03c30ce556433310d3666c71e384c89be279c7978"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4be25c122df36135cd5ef12c96f3a56cb9f84f0fbca8af7d4642c016b2e360b"
    sha256 cellar: :any,                 arm64_sequoia: "5a33ae98f6647edea48f036c143f5ecd286dd40e987fbb9b02d32087582b2f68"
    sha256 cellar: :any,                 arm64_sonoma:  "5a33ae98f6647edea48f036c143f5ecd286dd40e987fbb9b02d32087582b2f68"
    sha256 cellar: :any,                 sonoma:        "f1b975d3034c1caea1b6db1ee62ba3bd5ff65297f4d1b387be16e614e8063673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5f3bb853314de40c5e35e640a29de665460cc3c9955924f7af174b0e395ca41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce39db57c8a2a65a6c6674b1833521ce34ceabc2ee7d75e258fd71424eeeda3f"
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