class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.76.tar.gz"
  sha256 "0be546fa3a70590bffc1ccebad40eaa10f326c8ebfc4f5fe35da1a5cf76664e3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f71ab9946182f633a29640abf3e87965704b91b5c1b0daf79aedb4b04d13f8bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f791b43b7e811fe160f6877811391caaa28093a927b57364a5e501ae160cbace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b99f13bdf6ce94525ae330acae828c3c8769c35d5ec5c8485528eecbd178292b"
    sha256 cellar: :any,                 arm64_linux:       "801274e224157cec61559cdb59c331a465ffda4523acd6a8113fdae8f9333900"
    sha256 cellar: :any,                 x86_64_linux:      "545325d623b2957f97d1e76438cc4a20076ff5dfd18ee2c3d3a268eb7cb351bc"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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