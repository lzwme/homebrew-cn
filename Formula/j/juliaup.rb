class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "ded8173e7f87accd142969431136953174e75256d3d83ecbf6bfb6177fcf94f5"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6640ac7f5238859be986bcdfb2dfe43a587de4501b775f531da355103bd3a03a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7836f494fda9ca9ad393987ed93c1eb7116f020038e6d562dd9d2f812abad67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d03bfc53784362e988b441361a176ed9bc6f9856adb1627478e29c17bfae44"
    sha256 cellar: :any_skip_relocation, sonoma:        "78e51970998117829491d42ba5c60a6f9b6fbd79d3da5dd7038f30d06a1c9b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53f36aacf7e1ebab85411ea6bec61a64ddcc0f646b92e84c000398f8da1a4c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff7bcfd3afe86f99b3557f02a4cb959fae5a2bc0e1e8fbdca7e03f001069ce6"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end