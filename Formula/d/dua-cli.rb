class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "3972a34ffaaeb3c24d0693e13386a4578530333789b467c83f1686584f314291"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ea216cca97b55362380a1fa942f674ab95ec4ff07c8950fdabeec440cdd0570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59c15410f8ffde00ac52c0d7973a0ad19f23acf2a9f457a5eb6bbbecb37db20d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13031fc80cd464bd34b0e928f7180422ae49398d9546d3aff9bed5f1ff7de386"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7c7b7e8b5c2c3166ec49d1ce2e8d2da96932fc5e965ec6820fcf93e766557a2"
    sha256 cellar: :any,                 arm64_linux:   "7da1e6cac59af17fef9c8be54541aba4af9aca8db988eac170a4ec7906df6cf4"
    sha256 cellar: :any,                 x86_64_linux:  "38f5aca89d2cb145f3e399e067324d7744fed8109721cade4db2eb1ec22bc923"
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