class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://ghfast.top/https://github.com/eitsupi/arf/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "632230def183251c973d57a1e974d0b1f1b5918e35e77d2d5617e36590fcbb0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87a3285876edaedce71bc64aea2f63a4440eaed211b2468aaab6f7dc1fc91878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d3a9a30fe287ecedc1575cb844d8a7c396b2aca0f022029bfee3b0c6621a289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cffa69b01edc79df482cd0aa2fb291b310e01957ec45c55eca48c010b81c16e"
    sha256 cellar: :any_skip_relocation, sonoma:        "09e404185902fc3f20d640a25d2466738717ebeabfd8392895d938340f75bc21"
    sha256 cellar: :any,                 arm64_linux:   "fa7ebbeb384d09daed7bb319795364a83cb03c7b2e07602b50f14f1063fcbf87"
    sha256 cellar: :any,                 x86_64_linux:  "37a0d0adbee09b4ca2ea928412ebdc84621749f75f3f48c440d1c5c0d5704c64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end