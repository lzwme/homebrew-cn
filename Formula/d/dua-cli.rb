class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "8163cdbdba2cc8e35450a31c64b7a334b6b1f22a07ae737824e355ddd896de19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6b50dd3e58943338b3c1a6cc7ec16f333ebd13515eed349172d47978cd73fdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac567e2d5aa386f8d9aa9149b06ef3c647a7c9c5e93495f719a8a9b5031a34e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64064b22ea2b575e6d7852b7a7499039db47336b5d02340a37267c8e8dd4dd7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e43ad477e1c3af7a50396565b0e441b36ec36ca2af666f62d4618b06da75ed6e"
    sha256 cellar: :any,                 arm64_linux:   "89914c2b840fe0794c2d7502b1bbaaa74a3768feaf7168f4f40404bc56844112"
    sha256 cellar: :any,                 x86_64_linux:  "605eab16bd852e120e7d8ff7c3b73af32d2010b4ec5e8d32a8c99e8e1fbe8091"
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