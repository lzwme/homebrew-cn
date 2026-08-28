class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.62.tar.gz"
  sha256 "0d2e2dd1679ea5d3df7a092cd6f42d7153c58f3f50f8e4c1f5d714b5d50275c5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb740227f59537cc5a0d7e525d29468f5ab04741b62b10efec42c387844f4dd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9deb9fb9793db15cb67283bde8e89d1f03e805b1968d4c2d98229355ec24c302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c067c038738f9bfa386bebeeba0a5760cec7c3c84ed3953f5d3a47a325b23f"
    sha256 cellar: :any,                 arm64_linux:   "7756bd98216f8fb22ac434a99fe04fa998f6a941b09d981224dddc5202327ab9"
    sha256 cellar: :any,                 x86_64_linux:  "eba5dea918f5a748464d827e03dee0d9e2db3a5d5edfb6f7269ff9fbfa043912"
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