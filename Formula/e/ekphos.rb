class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.netlify.app/docs"
  url "https://ghfast.top/https://github.com/hanebox/ekphos/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "0aa0b4985db562bd2320b95291506ef8d734ebc2bbc66d6b21339f55fa412ff4"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ae5e790796ce8ff6ba1fdb420eca0b4b4075d909505418203dafe0e577e346f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b4c47ee11e1f7acf088a92c35f6f74b94fa7c5ba61f890b06fa68793acd473"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73b23b69b26d8003ec6650583480f774e38e0ed45799169bfcc46395ac874aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "140f814be013c2cec1c43e9375bb5e182821fbb81890379c1eb06639e560d198"
    sha256 cellar: :any,                 arm64_linux:   "a82d6fb7c792f48757dcf8ccd6c7a9678b8859f93d06079315d99e8c0caa5483"
    sha256 cellar: :any,                 x86_64_linux:  "b807e2286166d3d1acecb91d0357355ada4a9d7e59fdd0b7f363ac532e2844c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end