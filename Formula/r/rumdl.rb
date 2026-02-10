class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "5662a4d0944504d39a97a45da79a01227a02b54efdbf6778b198faf4492ad04f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "751395acbf7c80b8d991d29cfd710dda7319eef971110181a82cc05dc90b5307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26e19ac19205a32b7239bd637bf4cd1a18080df73ec4c3202c8f6cd69416e841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6225a4b811255a96b4e7d689cefc682cc13b9384a952dc3ea6a611f9f9d9cf39"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb288e55949ecf8f8a81a50f3da17a231cf2243412941950a65d169d6ce765f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ed3c4679f8986c06f2e543879ceb11ba4e23076a872d1fa2320ff2229dcfee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33e0e3ef8108be88087242b683f9d82735b8f3fcabf8f3837463ad34b8657db"
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