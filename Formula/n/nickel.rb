class Nickel < Formula
  desc "Better configuration for less"
  homepage "https:github.comtweagnickel"
  url "https:github.comtweagnickelarchiverefstags1.4.0.tar.gz"
  sha256 "e5a96d962ab4948b480cd53dbfb5c1e15fd35673216f0920d99ac2e5002e2eb4"
  license "MIT"
  head "https:github.comtweagnickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51c26d1e1bcf1520c6a8f3ae1d7a1496ec7ea83c74278d28b5da37233d80d768"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eda7e60cfb704799f6259ad400a12db18743b61f5b1c5ef35cbbe22617c79be3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed1bf7663212eff65d88daeb0e1bf4982c08dbd107a4c9fd903d3ba33dd1f17"
    sha256 cellar: :any_skip_relocation, sonoma:         "55e7fa536ad12823313457e5af3e3d462ba43181371ee40afc2e35a4665f37ab"
    sha256 cellar: :any_skip_relocation, ventura:        "171035f4032b4427934c28f74d3ea7d4a9cd01b6fba923bf0a4a1fcd36be70aa"
    sha256 cellar: :any_skip_relocation, monterey:       "dd0094deec787ce15b108aaccccc36e4ef63d3d494fa44e80f3c3797015e6981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6352e4ca2da0705fe9b1730846a33adff20892390409490436497331206be86c"
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