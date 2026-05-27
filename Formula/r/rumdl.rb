class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "b1692e47cd7af3177bc9fa1f37bfab31afbee9cdb6fd7fc48576aceda99ae1d9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2477cb64434867d2c373690c84ddc150321a71d9f76ccbc459d8e34b80163cc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a783d60d01a0761f56cbeb15ee3bb3ed6e9d7b8446e751de824fe2883fdd482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9b0c326ce1523d465bc42c773b1bdcfeecb3cc60f3d6667c547c01c3473654"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ef46ec952f6a31b87b2f6e5635d96bc09ddcd09e7703989acfa0501fcb6f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15b6d6fcd8d00950f3e0002fce788ef00287ab182438a444205122aa41c19915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f36d36ce37b020f13e3b0c42894e9ffcd35371a8cdf4dd57d063e5891bcd40"
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