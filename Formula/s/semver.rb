class Semver < Formula
  desc "Semantic version parser for node (the one npm uses)"
  homepage "https://github.com/npm/node-semver"
  url "https://ghfast.top/https://github.com/npm/node-semver/archive/refs/tags/v7.8.1.tar.gz"
  sha256 "6ebe127bfe811ce7daf2c0107246672084e9ef2e001cf584a2272b7a583e0451"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0dc144d4ad7da6d3e0f4e4a70deed8659e32b8e8f91aa92bf1643862a8abc3e"
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