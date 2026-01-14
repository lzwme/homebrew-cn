class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.216.tar.gz"
  sha256 "fd84c8a6c9cbb9e1899e0d2ba6fe543f8ddb12915b5774906fba99c8b370d231"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35e3bcefe805c62d4b61a4e388297e476579997a7341807905b7648c3f5e2b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5858d6dd19d2b043ecf21cd5ba31dcb3d2571f5eb3f0a690d33ec2fb2b2e3b14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ec55fd13332e915df846d473ad2f6e14e6e96f9198f510eede43210fef6b8a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "25fe835e34c3740b6d784a6b6ee3ad1f029a165890615607a82a69a727f5be00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6128bc6ccf885239f9ab4af9218f60a2830afcd101608c6db18bd48d49dac086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ade65d9a4fdcd9fa28f023bed322767539bad3efbc4353c8811c0204c1471b"
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