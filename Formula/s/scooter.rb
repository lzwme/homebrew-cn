class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://ghfast.top/https://github.com/thomasschafer/scooter/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "b6133e9b7ce8e58fe7dd29750247d9d9d6708b19a4a1d4972d19fad24efb2d8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d426b841a7277b4752e3113c1351c4a4aa0f6a1a2eb75500c4c18df3495648d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcb38dcd09a1ae5d934e3550bd15f8605ef88ae26435684f7661f694bed96bd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2940136ebb2c302c22a7c64c5fae677bbcc4ac035450aa38584ef8c728aff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "24cc3b9789139addea6b00d5e01d0027bcba8b5dead5278314de337fabb38d64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a6c9b4ddfd96582d3031d43aafd99ab2e0e552378b0673eefb6486b24e8845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96cbe028d82b736d1b35bb85d33867d542b8411e4de71d833882b7e2e2b6e55"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end