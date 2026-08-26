class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "0bdce37da1f5a3c04cb6b72e22fe3b02863367199c0af25201438ea101ab55e2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a48dc367c13201efe623b7b24316ccfa250b809dc306f4e9523379979acfde72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e7cf9e2f31679f8df66f1e41f6bcf79255261192bfd941135be4483761f1350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb1dca5bca7dbb82dc1b9d8b8c82dd9b65e11adb5ff9723f2453a70e7cfc52e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2695769748b4ef1e1a12fdc3c5eca301b740289334209367ee0c095aa549e775"
    sha256 cellar: :any,                 arm64_linux:   "427a33234ee172febfc53ac1b80dc8c47bbcf6faa7ccfca38c0d8a97564505dc"
    sha256 cellar: :any,                 x86_64_linux:  "2d96d1e9773e42c722fdca29ae6d4cbab6a5d444bf3733f71c59db21974fa76d"
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