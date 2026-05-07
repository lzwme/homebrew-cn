class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.89.tar.gz"
  sha256 "26d691c260454b0208e80c03bc1df3d3a07f6870500a50b7597d3a4598ee8e6b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afb5a7ec18d51e5ed68f444de16eb1e8c4cbbbacc7c57d281eb47f498039f708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dde50ef0e5a7f428175eefda2644e642a65f78801cd3f491ca858666cf5be39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d4cb8a468befa24429b7ce9924352efd83d6b90f9437a6f9a9e97247b916d11"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff9bf79f3039fb50b27a0aada1640cce6b10795107f62c8a1f7df4ad8b324510"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4febc3346ecc34a72eaed19e5d0e38bdb1bcdde883cd9b990d2de0542b631ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b9ae78ea715eeda3872d51f274f06474b0ddcfccdb5e9ee570deb0d4cb3f26"
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