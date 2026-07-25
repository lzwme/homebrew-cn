class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://ghfast.top/https://github.com/vladkens/macmon/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e96d62f2a5c26591824a434d2a9495abed0b4a50c31da710fbecce2759e3b0af"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fdc3d4a070b99f1f2e3629a8c05a720a924026642bf0409fe24d871a77332c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd191b285a1b426e49a46e4a6e91e3c1bac0f56a46d5f21261d67968871905e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab3ca88b7c75940b267bba60c8e0242a0f46a9ec3a22ce4f419aa939ba007dad"
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