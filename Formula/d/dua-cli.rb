class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.45.1.tar.gz"
  sha256 "d75fd6cb1c6a470b53d55051401a903f175a8a68d92d7d12d2c538fd8e70036e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1228a5aee384a77ff614879029cbf4864be9d47dd7ef34611348e8a3262a8682"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d019a1762c7aa7a9ab614982dac013b3924d2f81879b1901927f4105e80231a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2763c5136b034e898e9f0436f530ee830c36c71cb443908866d5e717197761d8"
    sha256 cellar: :any,                 arm64_linux:       "1ee924c5766d98b2e02769f478e0fe9c7d12ed15c1ecbcb6632bc07c0d363786"
    sha256 cellar: :any,                 x86_64_linux:      "5d1401da6248d8473220cc997b0e8afdc67a88fb6d6cdfd9c3a30c610fe5748c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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