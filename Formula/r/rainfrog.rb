class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "57a11a6a2287a9cd180f72f71e5f57617ded89ee1d22ab5e7ffe59d124ab9ef3"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4d0dd54aac1a1f157301547766d58e41aab443518e7180e44afbf021dbb3748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d46519d9c462ca40be42ba4224f0d7af89d23b195f4da2f97af5729d161b23c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415e4f41b8afc30210c4996528e930fb084fecd15612ae360b190e0a96b2dc7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43505124a06b79b8c13f942f4a8061514f039f21ba0704ffd3d015bf0246775c"
    sha256 cellar: :any,                 arm64_linux:   "7217924ede81e18681253ea21e11ee766ef70f20e17bb61a0d2daf06b9d51ef4"
    sha256 cellar: :any,                 x86_64_linux:  "fb1572fbe225ec4a747045f95c1930132427f923a1b413cfeb59fa95a5b0254b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end