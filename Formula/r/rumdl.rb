class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "ef31f0de3f2f378369d3810ce5b4f3ddd27e9c5387ccf12603dc708234d1a3f5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10be32276b6ca964e2eed564c961588eb7281073f74c5ea8e3bd2ebc82609d13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4004cd18a1e3dae7ed51cd0b95ef6c2f8d1143b75281a6f370f4042d0e9e7c0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a9971195c1c7b7a4e64e4f6619ba0707e0d4dafc913de2ba17bb19bbd15501a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4db8e66adf0f8034dcd10d2b058db689f2878ccd925f9bc3dc446e3816bd820"
    sha256 cellar: :any,                 arm64_linux:   "f6fd3bf3e1c68b808c810e6fc2f0625520b9c35fa4ed91c2d8ebfa8cb9f7a48f"
    sha256 cellar: :any,                 x86_64_linux:  "9854a9d953dcc3ee153e555bf4cf881b553e42b11657734565d6a5f2eb7a63fe"
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