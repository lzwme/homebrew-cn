class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.28.2.tgz"
  sha256 "95fdf97186d083314cce291b7b50b1e192e81f065ef3e9a2c7f159dbfc878a4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b4c55c9e5ff9e5232b3cd52938161a3e44901cd9c59ff66ebdef60ada35d488"
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