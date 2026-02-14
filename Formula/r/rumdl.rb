class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "b31f33d9001fd9018fcb4034ecf65f39131b80878860ab5c9ffec405ac1a4ddb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d88482d30b66b607150e473f51799433d9e5e3324e37bd068d7398679312bcca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f75d2d27a9a11f07a76a1e71859dceb3d34eb71f2a84902aa1e9238fc006910f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0304127d36b6cae759c24d73d6c9d1f787de8c7cc46d48a630c692135284fc5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddaecf9df898a526dba5ea4ffda3753f8b1423f5116f3473435313602a7ef0e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b51371321b77078ead5dd9a4d42993e2e17700a4ef10f60086adb078282beff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bcb7e4632db2ad83b74f3fb55eba6c8c351e975d109fabf74072e04d00ba3e"
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