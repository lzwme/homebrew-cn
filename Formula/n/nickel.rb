class Nickel < Formula
  desc "Better configuration for less"
  homepage "https:nickel-lang.org"
  url "https:github.comtweagnickelarchiverefstags1.12.1.tar.gz"
  sha256 "b85323b64c082d73dd25b7235e0dc299066f2395fea8846cacb43cc1a70d5840"
  license "MIT"
  head "https:github.comtweagnickel.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?((?!9\.9\.9)\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ecc1f6f575c0af9c8a155c57b563a3ca4314adee379693b310e4fba5e02026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edb3696ec0ba7c71ed81226242698afe453672423fe3aaab5d9f610ae272bd5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b923beae3e1634b6056ab1da95d31e97d18e343e635c73fcc78ad07a11c8135c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fb1a80a629b9e129c43964e16c10a92e40f441ba010663da0feb22c8254f852"
    sha256 cellar: :any_skip_relocation, ventura:       "9e5d88eb13bac2d3cf05e2c36d3544c1312f7e8c5b2ec50fe85a88b4c95385d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6cc9190e577cbb18e8e5fb6f5993e742552796715aa3374aa89d263f9a08309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c18c17eaf22b538658f9b34856b42743ad0ba7bb19be62d5a7a50f47c24c92"
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