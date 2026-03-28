class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.3.8.tgz"
  sha256 "aebb12b544137970e2308a6601b418fc68aed0c3873f13fe5ae33111bc1b1145"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d733812d92a1c4387da69f6299dac243e21983fee282b2b0cbc76fc12345db6"
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