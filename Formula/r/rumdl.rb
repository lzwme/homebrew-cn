class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "839d6f32d8e8951a102b1029dce499190f24536ea557ba264e19c26f19631fee"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "257faea36d400dce0ed9ab08f3080cf2f0da9234b8617c8dfb341fff13cbf166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a59311b33ac6673d3be512c1de4434336645579b935822f760931ae71e0c8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a8d1747c6fecf7db3317449b8009a4ea2c805b85d6ea675881fc948caeb939f"
    sha256 cellar: :any_skip_relocation, sonoma:        "078539ccc3c8446560ad1f651490011e066f34ec1d5451009414bd7105dadefe"
    sha256 cellar: :any,                 arm64_linux:   "d1b32d6248843f518568bbe5f9120fb87b7da024f5252d1d87c18632e2eeaec8"
    sha256 cellar: :any,                 x86_64_linux:  "c1c5dbc412a174856e8f018dc34cc43b1c10379884fdbefb9ccb29aad6575b9e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end