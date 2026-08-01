class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.47.tar.gz"
  sha256 "11534ad63f84cc5602e60486405e77cf7445ab1a1bde38949ed2b3677f8fc897"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dac1910d7fcb24410eb693b3d93b9cbacd07bbeeae4e56a3456c1b16490b6284"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75f095acaaad1d97bd587c652a94282a74dd133a65c52cab641c313c8cda722a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2086d97e66c3f64de9be4f200c014ee8db9f6b081f001a152f183344357b9fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "01dab07ae60e30cc4bd7f0ab86ed8a64583d4122b683ca807432258b9e165ae5"
    sha256 cellar: :any,                 arm64_linux:   "c5a5f489dcd75c3d446e53cfef1ddc56db52669e0498859b37161ba7ffd6e723"
    sha256 cellar: :any,                 x86_64_linux:  "b1db9639f85c65d30d139def29aa607556be0e6e6d212a965e35197b00da3159"
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