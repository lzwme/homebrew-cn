class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://ghfast.top/https://github.com/vladkens/macmon/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e3708d4da099d1e22e71384fe8ea0445aa2549d5198c569cdfb2fe75672f90c6"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9484530b11b84f3f9aafa1e5f1d7c582f936cc42a0ed745beabfa8aeeff349b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a74c80682a02a178d04e31f58deae189e2fd763023e8256adbdfa5740fa39294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6eccaa90ad2ba96bb72742c22e0c1dbe5cab266e55c1ada99f9d10aefc3a43cc"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to create subscription", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end