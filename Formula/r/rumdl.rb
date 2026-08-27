class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.61.tar.gz"
  sha256 "f93015c6fdb83d74a4c1a99edf4d2d95b5df54b13e23dba1a860160ce3699cfa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0148a478f24168c36c4aabcd5b8f34a81eb255eb4f1ea04a30e87b47e19da33a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee5f00d56da13539e3e8dcd6d0ef34887664134d0a79a2cea4cbab1c755d8f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c79d57fd06a319934fd4769001c24f8de37f8fab70afbc14026383ff0027e702"
    sha256 cellar: :any_skip_relocation, sonoma:        "f412fca0d27a7e824eb87d57c93ec16a3d60aec8f273e789cccef659e6015b01"
    sha256 cellar: :any,                 arm64_linux:   "af82dab12d505fa4322bbd6b4f52f231f37d9ce8a6fae2dc171b163467913dea"
    sha256 cellar: :any,                 x86_64_linux:  "273f1ba702b0450761d06801e01a7990d3b9daf7bdfa58cbfd9604cf9505f91e"
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