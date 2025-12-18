class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.3.0.tgz"
  sha256 "81714c4ac547e73ddbc6b77af45905a1bdc94270b3d87be41990ac5b39e62781"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a88a1be3edd60ef0d6314a6c8d1a89f31db34fc447a225c6dcc6af709710733b"
    sha256 cellar: :any,                 arm64_sequoia: "4458437c82eeabf2f419946829881be714367677d3ad433aa817861bdae4008d"
    sha256 cellar: :any,                 arm64_sonoma:  "4458437c82eeabf2f419946829881be714367677d3ad433aa817861bdae4008d"
    sha256 cellar: :any,                 sonoma:        "abe3dff32698da31a4cfb24496df9543e9ddd41dbc7a4441babfd220565c93e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4895a2d99f19bd06eed8c417c1bdb75b10daecdf0d3b58ea20f5d24979fff449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58adb6a6d0a2590300b1f940c1a668e4efbf09cdec8eb7e00df357f7e8670b5"
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