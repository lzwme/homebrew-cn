class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.20.9.tar.gz"
  sha256 "be69ba98c8c46c2ad58fe8f4e9134a2d0a8eab3b76231ca056613016d3a20815"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbdb6e2ffe8929c6af243afd3d21fb73c0b2fdb3836731f0fb8a5cb18d95a6da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8f52df4f208d7d24b2443a0451a8402ca13bc2a7c1431939e56ab852fd2659d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6a0f89e1d1c55a3f95accaac1115501a30c4c98ba7de9271f548f60d8932ccf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0718d00d253c281bbeb26000c00816d0c532bda02cb3bee542745f99a08a8b0"
    sha256 cellar: :any,                 arm64_linux:   "fa14410d2cb6b0b06be725ab08b9f75ef5227d5415f1a66edf70a65a3cf4e6eb"
    sha256 cellar: :any,                 x86_64_linux:  "1db4852431c7150255b30c74e5ab5e9f19a916377dbd8b06294441e9204bbc0f"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end