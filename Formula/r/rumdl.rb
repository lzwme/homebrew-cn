class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.33.tar.gz"
  sha256 "af8736f2bdfd7a8bbfa6e5364fdea1d2e3d54870388c724ddda474c7366e4aac"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c832753a90df91f092436a3367c5ea844237df7381bbd1a4618ced4a7c438f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c5c4468ccfc0bc00ae988e52af38fd05b611f76f72b682f7a57b2e89efc5496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e86d4d3bae921172ed0155a8eba02c3ea0d863070eebaba21d32945c6dde311f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc9257f17e71cbb1a39488dcd024d088b37588e8bbbafc33ee75ae02795f704d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "006b38e62cabbc0d1758ecec32bd06e76a2fd1cedf840bf0871e4e9d90806f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd73d8154b615e7e2b1fd97b120df901e3c3f008b39667c0b99a41b323ba9be"
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