class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.3.10.tgz"
  sha256 "32c0dfc9b16cbcf6700e4de2e6bc2eb25117a65307a1a94ef96d3bd0c6116de2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f35309691e7e0cbcba1fbfb2469f5e9e6691e5d7d89b9b4b9d8ba72f35a65ef5"
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