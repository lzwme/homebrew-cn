class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https:github.comalexpovelsrgn"
  url "https:github.comalexpovelsrgnarchiverefstagssrgn-v0.13.5.tar.gz"
  sha256 "ecbe5b9a23e005aa30d5ad4fe3a6d19fdca0417a986646885edabbff628f3a7f"
  license "MIT"
  head "https:github.comalexpovelsrgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93fa0fa33a1622abc17a0f3cfbd9b4ea31b31f307017dcc32b14e1c4c9ddced9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd6757303a1d2b4c143d14d5649cd1c16dc2692480a1ad0bce181734238c8e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cb04f9721acfc5eed48dd7766d9081d8301f7f9ac08ce503d2a69cfd6aed728"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb0720f6ba7bc635f52aa5f9b56b04306032844a3a64e49221739ecafc409fef"
    sha256 cellar: :any_skip_relocation, ventura:       "baa5773503de179dd6591a2d004c66ba0194d838109edc6bbd9fc21b9009da28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3f325b506a885e4b71ad5673ecef5a488396fa21f261f51d5717a445d0c98a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e9e15c51b834c483e90a6f8ff845832e4d2de67c76143399f7f1b9cf24c84c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"srgn", "--completions")
  end

  test do
    assert_match "H____", pipe_output("#{bin}srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}srgn --version")
  end
end