class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "f70c507fb44b07fe6d0c15d444cd0c8b10cd7afb02d33bd079ef50bf95de8d2f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "143e5777d33473aca5fbd98f36763f79e80065aa32e6167b1082661f550fb59f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ca4698be607d6bd6215c1552ceafc78ce674abfab5d3ddd47761fa201a0b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66714ccef6441433279c904cc8e79cb0a07aa170cf9097e0593d60a7728ae2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e8beef6ab43b42267fa6831c596f4c6ab7a6ae76d77ebe7a9ed70b83d4e2efd"
    sha256 cellar: :any,                 arm64_linux:   "9c71a03f7e2609906d55ca8cf7543bacd95a83d0ad187453df68b39dc6a6b4bc"
    sha256 cellar: :any,                 x86_64_linux:  "fa9184b7e700ee05ec5f5bb3d2b5d5dc6a01f23b5d26e0e02f47fdb556e54d88"
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