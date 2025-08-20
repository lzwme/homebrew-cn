class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.64.0.tgz"
  sha256 "1ddfcf0dc8287e4aae849e09956e7a8013251a8edacdeffa97f6508f5a3fd28c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "777adf32a2a4bbcef965a499bb4d85c968a8f3471510a239403c63c4114d5357"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read

    output = shell_output("#{bin}/rulesync status")
    assert_match ".rulesync directory: ✅ Found", output
  end
end