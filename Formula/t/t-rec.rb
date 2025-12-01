class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://ghfast.top/https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7e7b8a99b2fc29a67ca798726376da59d58f5c010f207ff427137541ecbbe8c5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "852a7ac1fb4100e661f0362148e037b98f6265f80e0acfea231f04cd7b061021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef99e88ecc19a351b3b5bb4ca629329306df5acae5bb92677bafdc597126079"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2448a0566e75ce35dc8dde2a03393d919645ffc83cab945556f5254607c712b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3589d7616135b56fa6f1d19d2546366b55592e23454efd8e81b6d10d15a203fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da2b0275e3b643dc7e1170744fa49e99b2be3b650a064e3c94849da35a76105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654217c6f18d4b2f575a10174361199135a083c5657fa0765d02d335fdab6bd2"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: $DISPLAY variable not set and no value was provided explicitly", o
    end
  end
end