class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.43.1.tar.gz"
  sha256 "b4cd68d0a5cf1a4c606a5c9100063dd862d9d2a5b5dbc5c8fb11abd127816f2d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61fac887b7e48ab0f154a4e759f2e8ab8332ddadfaaa0ee0069c81a7ba95f4c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea4b51fff3a20db8ce17299bb0f4f2197c298e01d8bbbe9fbcab3feac4addc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "105293f3dacb67f6acb0b48259c377eee43081caa3285d90684b5d98c733868f"
    sha256 cellar: :any,                 arm64_linux:   "8e2ed407c23799825d40dfdccd0a008a3db65ea455ea40e7bfda23d5b09e5d01"
    sha256 cellar: :any,                 x86_64_linux:  "5b507096225f4035b9b8192a5007f40596126f1f72079a23f74b6332f9565d6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \s*0\s*B\s*#{testpath}/empty.txt\n
      \s*2\s*B\s*#{testpath}/file.txt\n
      \s*2\s*B\s*total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end