class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.210.tar.gz"
  sha256 "d0fcee891b3a19fcaa4edfd64c4d5c204e9b85a36102981008f335649d1942f9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42e3703e737b9f865fecdcf4f578f6f2b3d2bccab79875ec1dfa37b7957270c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bef6c20560966dfdfc5be3ef17291d7accacce112ff63bbf90fea4d1c4243f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd4fc9cd4ceec1f915c279190e0056d3b2237756d0861f29e42c89f8a3fade67"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fea3fd839aa825cefcba193cdc3f785e60956afd6c7b51e4fa6359ac6bdffab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b146fcc8e510076512ccdf1a2a6eb499a33ba490a5708dd052cf6b5d390a83da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c97417e8b89eb43b28e12353c3138f5ea3b2f7e5beb37af317f4722030e8af9"
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