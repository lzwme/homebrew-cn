class Semver < Formula
  desc "Semantic version parser for node (the one npm uses)"
  homepage "https://semver.npmjs.com/"
  url "https://ghfast.top/https://github.com/npm/node-semver/archive/refs/tags/v7.8.4.tar.gz"
  sha256 "16714f35def7bd981cc9afd23401a253e30dbac1e89e6b0e440bc719f8f38874"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2effdb025381257a04c1aa0b1c541a169934dc6a15465171281393741483dcb2"
  end
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semver --help")
    assert_match "1.2.3", shell_output("#{bin}/semver 1.2.3-beta.1 -i release")
  end
end