class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.194.tar.gz"
  sha256 "29071c7fa3e7eaa295cb14f8577884d2f11724b5b59d614fbcc22185738ae036"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364c83cc226244e8dee272713413eedf8898e6f5bf0f272d8f0fae0db05af536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e8b9d6f9339f3bdba9ea384eaf9bad42854e4c995dfd16ea7ee5c5c41a8fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfa07ed4c5f88285ba3c18fe7698744b536cfcd31dd09864327d4ee8cebb0c56"
    sha256 cellar: :any_skip_relocation, sonoma:        "90b4eb04901d5fb879cc6cc1b9e9e82a51651062c512db39fb377e6dd62f78e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa7dddb2d3573c204a73edf89b237dbbb5170ebdb291190b017e1060ee47aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d44a8ccfb041b025292493ce10b2db20006098061b5a687b63ac4ae2ea8880"
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