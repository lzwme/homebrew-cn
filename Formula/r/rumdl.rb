class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.217.tar.gz"
  sha256 "e08899d01338394404fff25daef061a18625379fc135711b8941ec5ff4dfacf0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2a4c806346115b235d290e978b374ad4334d1640c2f886f951d10e254928184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b485dfd8552806e6f3626a3f0a65e857bde43f9ffe495a39230662138370d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c66fb281213ba5e9a98dc26da6ff65b4b18d7937670f6a5ebde5b6cc8df6affe"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c51fc910cc3c99cd8378110d3b5c3756db2f3a5f82be794dcf05da842aa6be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b992fa651ff20c9f9f9e06c228f10f2fd0d573962fcd1903814e194ac7d91002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd758a50d2e27963fd54922b64acd6c683ed158e41622b89a3cce5c9653d738c"
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