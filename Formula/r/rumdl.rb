class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.74.tar.gz"
  sha256 "b4f2f89c5532b76fc96decc50cd055043be37ffa6c7b504fe6b1ab05568cc8dc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44293e90001c1b5a9b20af165e410ea061477ae242472634945b3f09ba89a990"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a3898a0fcbcc2f0de0fc286a0f4ced0553e5df29a005f2d53f8a5bcb4bbba6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae8cb29651df54270603385449db80092c1f0d0a155580543cc15408ae0aaabe"
    sha256 cellar: :any,                 arm64_linux:       "9fa649d1a7e1472e63484abe0e70676bf1323359ea67df2b4bd575a84abcd098"
    sha256 cellar: :any,                 x86_64_linux:      "6799c5a00940e7e664e340fcc054f1659a721f56c30738da9a57e6aaa8975e7b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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