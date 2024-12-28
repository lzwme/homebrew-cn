class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https:trippy.cli.rs"
  url "https:github.comfujiapple852trippyarchiverefstags0.12.1.tar.gz"
  sha256 "ae868123cba03977786f0dd74297f2e15e021d753684bd6e47554003f03a3d5b"
  license "Apache-2.0"
  head "https:github.comfujiapple852trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad621cefa8595b31dec20b0638265041703a1e1904c0b62c777563ea07d265ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be9dc1e4f6aae077ff542e20edccad53c2a666da0415c2f9df1ed0cd927a758"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "454a7509ac48d2a6ad3e73cd36f54411577452222f453c0bbb0f31e25f1e2474"
    sha256 cellar: :any_skip_relocation, sonoma:        "13b62cbb1c4c5aee1eebdce977cda78cc23b3c3ce51dbcb6d08bbfcec69c3852"
    sha256 cellar: :any_skip_relocation, ventura:       "b3c7949a55372ebec3d1acc2abfc0365f3cbd68c997b269618782edf6883c14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69dc123d2bb651b1744b11664248821940b43a226141a182909d4c2790ba99b0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestrippy")

    generate_completions_from_executable(bin"trip", "--generate")
  end

  test do
    # https:github.comfujiapple852trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}trip --version")
  end
end