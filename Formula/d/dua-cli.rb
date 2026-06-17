class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "b6084b232accd41d6ed85b4639ee4d567bef574439179b0b7def06e07d288c55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1d09b10a79cc716f461134a301540218fc07589b1ce4a23958dfcba5e72783"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07aec0c9d505247687ecb03660508b15a2cd59ac8c27065736386602be311e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d24203303fe30184ff4e27a668dd34c673c54d0cab8fc3312901b80ebedd330"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5482ab7992e715479a46a057d2cae8e74f97316e27ceeef9a2c6a832927a772"
    sha256 cellar: :any,                 arm64_linux:   "07ac19f3dfe82b7b2d0d1ca8b684e32cf3c7b52000330d853d52610515f41907"
    sha256 cellar: :any,                 x86_64_linux:  "a6e07f270b4e8fd5806f57341b0b7e40f3488714b31f065e9e6b926b10a5f8c4"
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