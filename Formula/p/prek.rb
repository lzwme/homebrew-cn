class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "21c9bec0eac881761a6ad7a6f918e49a2436c9d85256b583ab930d947935f9e9"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05abdc9912cd38716616bd555dd7ab2b4cfe82a2d8168d4be939927c0e170c41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21fbe585e3d797c62cd64330dfaec0d9415100a8da2842413dce63265de5d1a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0247310e9a15582b42411c03e71c1a4dece115c2d942b8da476ef76069e4b06c"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ba379d10fa8cb02c259d26c905b13f080b05db6a9fdff97812b1db0400f13b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86bf8e75fa40f1cd78b3ace146aa6aae5282b347429c29da48d2af6f667aa1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a9b559460439569825fd2fd11e3b346f5b83dd87a64596f01b2eaf7f733b35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end