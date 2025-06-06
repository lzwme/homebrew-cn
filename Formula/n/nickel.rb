class Nickel < Formula
  desc "Better configuration for less"
  homepage "https:nickel-lang.org"
  url "https:github.comtweagnickelarchiverefstags1.12.0.tar.gz"
  sha256 "7c5fa70c5fde72dd8dc8e7a67d49df8699aaf4e71901ba983bc2fa4fa317de8c"
  license "MIT"
  head "https:github.comtweagnickel.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?((?!9\.9\.9)\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9095dcc4557e521e5bbe3b1547486e8f3ee1e7cbd1c418b048da27a4e0657fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "417b6824bd2e2fcdc3b606f11f5044065af05d431bc83479c2b726c5ef93312f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06125c9b11ef0f9d07f1e027378defbb368dd50ddc17dc76d5d8eb19b6ada48f"
    sha256 cellar: :any_skip_relocation, sonoma:        "793450ce85ea59ae705779bdb9de9430c334f412f07d2e9d53835ed2778ab4da"
    sha256 cellar: :any_skip_relocation, ventura:       "f187e63164a60d7db69cdf16457d6a4ce2c9f966cf5045792dd02800bfe54b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0371e0def463889b937a7ce42d724bfda39885d8bd7c317fc6226a49db68424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ade8a36a0a297ef076ffd761d51f623f4891b00d4a4d701312c4e0e757de87d"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nickel --version")

    (testpath"program.ncl").write <<~NICKEL
      let s = "world" in "Hello, " ++ s
    NICKEL

    output = shell_output("#{bin}nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end