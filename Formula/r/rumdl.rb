class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "881008de2b2b9aec8daf02db07b2149489340b18070923043d45269d4228d56a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63a9e577ba1e48faddcca9ce9d39e12563a7fa1153162993fcc547f2dbf3c006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3fa03b97d83e421607a31da46aa249982f724126aa44430789ea53b2ec271e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad84a0399e751c54aaac52c6d84c52e89f91186701d5403874c32ef069960ff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "382ac7f37744d1f6e1c44b3657bd7c61a1c0faba136f05eaddf5221e10561641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5452a9a7213e24e1a53de18b5852264465751c4ac2082acfefd4276689ffe33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b475d3654032d1d6389cc63b63eeb59aab1fb9d67bd0b5ccc5edeec101dd793a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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