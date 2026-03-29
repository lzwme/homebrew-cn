class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.3.9.tgz"
  sha256 "f2b8f470cb87edb3f05f2bf9c538d482ae0fc77b975fe096c8dfa04bc8ac87a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e256716f6bbdc42f72fbc91bf4fc172ebc8a67d2eacdb9b524bf9a0e1754950e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ctx7", "setup", "--cli", "--claude", "--yes", "--api-key", "ctx7sk_test_key"

    credentials = JSON.parse((testpath/".context7/credentials.json").read)
    assert_equal "ctx7sk_test_key", credentials["access_token"]
    assert_path_exists testpath/".claude/skills/find-docs/SKILL.md"

    assert_match "find-docs", shell_output("#{bin}/ctx7 skills list")

    assert_match "Invalid API key",
      shell_output("#{bin}/ctx7 library react hooks 2>&1", 1)
  end
end