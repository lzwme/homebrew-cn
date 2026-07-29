class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "ee7e9e6a778b06796b4febbe0f71375789b5cc6d7e4aed9cc6d5326ad4b37064"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb74fbe9cf3f9ad2feaf0763b44e33c394cea7089427bd5d5e83640a27efd984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8986bc16a7784248c8ed9f03a28aca6ac22565f9dabb2857c7bbb01c6b2fa88e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d0599dcffe55fa484e057e5d06f5d5c6d78ab4dd44cfc295d0079168b59b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "41579f7786d040680f0eba1ee252c696c3b17d2ac53dfa667571f1f4117d00bd"
    sha256 cellar: :any,                 arm64_linux:   "1f086cbde4a7d3a155365d5917999e8edfb678a347cf6ea2f2f3ae0aea1ef494"
    sha256 cellar: :any,                 x86_64_linux:  "777729e0aabf3831662d77496e2172473bda6fa002a1626f2a006e48f1a27e63"
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
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end