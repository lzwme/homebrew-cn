class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.87.tar.gz"
  sha256 "12cfb167ff5f56d59ea2404f44f80a8127b8100385a67f65b82b21ffcdc51469"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ba688626dbae4647d76ad577fda294f46ca8ccb90ffa20f8ce0cb356b8ece20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29deb33a7901c7b8a77a9ac879c263957691d7c3bac05c46aeefe640c4638af7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7ce1c094374cda4d32f4fe0762267221374e29e36fbd112c63a51a7430b7c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d37deaaad01eda59bea4263659d740fa12157559f14e3d29baa95219915b9c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eb1342f354a7b0fd5c70560bea619bf34821f86e4b6c030d5832ce0f4174bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8862f4caddcd09f13d0f04f82ddf2c52a2351d6a51cf7b3242c8adf657901a"
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