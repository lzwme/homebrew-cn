class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.37.tar.gz"
  sha256 "2f9556213efab1ccc543b43f63782345cb61c9afb30163e55002355dc1425621"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e9796260d55e8ff6b4be50844a41d5d0e320443f3e638cc2e98affd3e318e31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f86eef437715329fcd9e9c5b57349e12963adc9890a7357238dd1b108d0021d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ddcdb9a44e85afd107c1e3d1b4d58b6b5951e2d4f39d55630f41107f00e400a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7e61dd44bb74b0160b60859174c507412208aa99049fc07d6ebcca6c8f35c38"
    sha256 cellar: :any,                 arm64_linux:   "c3cf2be4f101207c8c02a5df18931543da6587bb9693537dec2b962e2bdd112c"
    sha256 cellar: :any,                 x86_64_linux:  "090c2eff91066cb08a3885fbf4ef3cc7f840b92b6c7313b22dc91fb8e19d4d22"
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