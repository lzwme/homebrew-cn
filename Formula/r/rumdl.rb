class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.45.tar.gz"
  sha256 "6a52a653c0972928b9506cf0ff0ca0fe510b5f86053d29863eefaff44fb293dd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4971d131748123383bf9fe49c53f48bc37caab3d56530465ea9df279499db568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "434ea86106ce8d14dcb4919c99f352fe32aff7ca6ecfeddd747a39fbb413c433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad24fdea5e05297968e463fa32ada616d1727b9c0261725d6368f8eeea64f76b"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e0351291e3f073137a7175c5626ffd9bfbdc991bf5278b27f0407e8ceb9dff"
    sha256 cellar: :any,                 arm64_linux:   "18e9382671da82baba20dd3a34bbe64d98e6a285db34410c1a57b72870aebefe"
    sha256 cellar: :any,                 x86_64_linux:  "63358da5e5acd2c99f67b64b2804bc385163d1cf65f37af9d02dbf9d96116710"
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