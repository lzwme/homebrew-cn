class Nickel < Formula
  desc "Better configuration for less"
  homepage "https:github.comtweagnickel"
  url "https:github.comtweagnickelarchiverefstags1.8.0.tar.gz"
  sha256 "0063cda11032c98b94590eb0f32ba2812c4d497612864fa1715a089918eb7c31"
  license "MIT"
  head "https:github.comtweagnickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d68ab5a67880681a786d6be92e63785c3a187cda9399d9accf4285c9aa29512b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8cfbbc93e5d2db984b22c306cdc5bfe0599f588f784fdb2785086d5d1475ad8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d052620849bc40dc9475d630e248aa73f4650fea01903a5d231f2562f47610"
    sha256 cellar: :any_skip_relocation, sonoma:         "95c1e76949010a1e466e1ef49f52e2eaa5c23be5be69ab090472a95de8546594"
    sha256 cellar: :any_skip_relocation, ventura:        "2a28b225166d59c9b722cf9d562d30f670dda3ab22fc6804a5e8e6752151d426"
    sha256 cellar: :any_skip_relocation, monterey:       "72f661240422ac0f7b302cc32ab61ff606981e17ec652b1d4ce7cff65f810568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8380bbb650b1cdb23b0b963f09d71c2fbf4910d199ff7e0fd6ef55dac69d08a0"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nickel --version")

    (testpath"program.ncl").write <<~EOS
      let s = "world" in "Hello, " ++ s
    EOS

    output = shell_output("#{bin}nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end