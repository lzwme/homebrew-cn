class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.211.tar.gz"
  sha256 "67ea3e5ad7cfcb61f6887954f284ff100353b1eeaec631ce83a523c8f46efa32"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f4d5bd178f2337666574265dd9b846b1c53ea89fe7d7b798759886dc38efecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d00d403a1162a4fe7209343bcaba984771c92b99bac4fc4091c21bcddd0715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71bc40acf421f4ed94595e80bc7d7915c4bb9a1dd44c3b5b0587fbebbd539ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4d36f24f7b9c19ee9a31eef1d88eff53649da1bf02363494d9ba18394215466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0849d8a20212646efe4d57cc538ff423abac9f3af1da80b7fcc6e9beed230453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d7e032d9f1a25e26f200d01a19a5ea13530840f0e3ea24f5a8fa7a0059dbe9"
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