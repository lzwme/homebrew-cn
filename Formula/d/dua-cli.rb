class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "feb4f0e3cdb2abf2dfd8ab9bdfbc7c43b07f0278b0ad6b02e9909149265aadf6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6d5074654c1ace040a08630ed5cc4c554f3404a19983eca21617ce32906dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe88364a76300406061a3081f6f0b0041a9de19f3ada1fc957f752af75267594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "747f6385907fe2e9fdba23b29013b43e9d4e16f99bf3961020a355e1d16d848a"
    sha256 cellar: :any_skip_relocation, sonoma:        "30d2e6d377d5e5357a38c4223218878c8c01e265d1efd08b22ee42612298e7aa"
    sha256 cellar: :any,                 arm64_linux:   "42ac0b101d25633e363f225c1bb19a0b827a3f3951556fef8f2a87a611e7f0b6"
    sha256 cellar: :any,                 x86_64_linux:  "d4a5cfda79c83341e699dfc079fcda7c5645dbae9d93b3c447cebccfb4f48ff1"
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