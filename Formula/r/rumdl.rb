class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.19.tar.gz"
  sha256 "b14fce5ffed92fac2b70b657d63a50faa059ba8424b31f6422783c3a827c7dfe"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d07e87b43b4db50ac4be43a1431168fe4423d2e2ea7ca6c1f2212c6d7125bee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca6d809db53e568ff5b5e7b6bff096c1e821af57c6344bec48232f34ab9fe61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb871c1d53f2718cb26e42b15aea117777e4098b95281750c73f6760607c18e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "74914c280ff8a8b05e2e0833328d166d13da0e31bc1c23a32f8a7478ec44818f"
    sha256 cellar: :any,                 arm64_linux:   "b66a7fd7e34e009e1904ff63e7dbd78d6f0ce72491464d9512a8aeedac8fbcdc"
    sha256 cellar: :any,                 x86_64_linux:  "93e68532f65698be9d7a1b0189ef7a699e321a835a212b52dda36187329909e7"
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