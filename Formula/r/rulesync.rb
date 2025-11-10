class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.15.0.tgz"
  sha256 "59ae850435c13dc43b3fd874791e71d93978bf2ae2fe2200a3691c004b04aecb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37979b45524ec2275ad588bf30654f7f0e2c8059ce7637216d49150197fc4d10"
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
  end
end