class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https:trippy.cli.rs"
  url "https:github.comfujiapple852trippyarchiverefstags0.12.0.tar.gz"
  sha256 "4baf5e9f4d4490148ca739af6dbf5234c79dc5f8882690575ade29ce7f9b60e8"
  license "Apache-2.0"
  head "https:github.comfujiapple852trippy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2586353d32528a86fa4e65ca973d4efc011268ed55f8727dd9aeb351b2436d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c6079e60a1223b43b989cdcf259f16a63acc1d3ccfe46c84545888b7b6965d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8a42ab3890c214ea2797abfb4d09198b76beed5b489277eda88af06b30e18cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2830e758a8ae1916eea92c9557863dcd7444f6ce9d66e63f3651d93c5daede9d"
    sha256 cellar: :any_skip_relocation, ventura:       "e3a4b37d4baf5ef41e0f3de0294ce797b26709ffbd9a5a29eea35aea99f8c546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c70229f253500c7478f10d9ed3ed20ecc62db0e4c2452010ba2635d892ef4e96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestrippy")

    generate_completions_from_executable(bin"trip", "--generate", base_name: "trip")
  end

  test do
    # https:github.comfujiapple852trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}trip --version")
  end
end