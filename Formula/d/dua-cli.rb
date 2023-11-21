class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghproxy.com/https://github.com/Byron/dua-cli/archive/refs/tags/v2.20.2.tar.gz"
  sha256 "4b7049e7a5f547272c558f03de30afa66b8e740e9e28f593012e8645f08b7f17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1eb571808b646d8b3ca1113505de41dde1648e2988e4177de71be3ca4cf4922f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74fff96e7b36a02ab5d6caa2748eeff3d32d0240c16a6106ccbdef5355aa4615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd80659a007b20926bc9a7f0986ac59b8bf5eed800e70d54b9eb42cae09058a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bad904a527da9de4c119af7a72874494b6579ea82c9e4bf8e2ef85d905d0252"
    sha256 cellar: :any_skip_relocation, ventura:        "79ab2869835104867a6758663d83dc670a5c9643b7f1be672218c0b499c4ac2b"
    sha256 cellar: :any_skip_relocation, monterey:       "5c1b3d688a3faa6ed08fc038f727bb4c6b979b087971f197e8a885d10cc131c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bfd484fd81f575a2a5975fb4b0936c766687f62b47c58df35284cbb165aaaa"
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