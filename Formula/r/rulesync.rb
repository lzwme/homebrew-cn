class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.77.0.tgz"
  sha256 "8381908d454070efd6ff3482e88cb409b40d08c7820e2ecd05de9cbd7c5b9aef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ae20d6a5db92b7c77d20857f964d664f9cda847b63384c02837bb3c300c1170"
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