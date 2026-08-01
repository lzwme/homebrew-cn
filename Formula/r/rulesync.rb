class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.3.0.tgz"
  sha256 "44ff162a48260541868750dcc96b02108cdbb818be3a4f67a6f4e486177e7d97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46feaf9d161c6018c75821450e013dfcaa5080559ba69c7f900f028a05194cb1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end