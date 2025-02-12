class Nickel < Formula
  desc "Better configuration for less"
  homepage "https:github.comtweagnickel"
  url "https:github.comtweagnickelarchiverefstags1.10.0.tar.gz"
  sha256 "15404075e20e45da3ff0e6ad54e94109c8fba2fbde1c2def00c1f3f4e8e3cbc8"
  license "MIT"
  head "https:github.comtweagnickel.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?((?!9\.9\.9)\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87880796aa810101047f974f61c304f3d96b8951cec459c046156dafa1609563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222702e569e533d339aceca8636a087f99c6e62bc54dcaf4bdd2617aa8882047"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d00323b764cc2a7fe90c39f3da3555b0be499855e5d551fc183d2a7aea5efce9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e0fc39c56c5261e764fb4fd464388444544b7b8abae4e6fd2d457aac9bf354"
    sha256 cellar: :any_skip_relocation, ventura:       "557d7335ec85106efa8a0aac95f73ced803137497d125101b53b7643fbe54aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6fa74f3a938260859111e34f846924815c2723e82d85b9da11a1cd8d72922e"
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