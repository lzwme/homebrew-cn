class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "e54262747f00fa09928f985562c55d9b8143b3559493015fa398ffb29a70a3c6"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b73404c7775ac41ce53d317806a8ebd721cefdd9989cc921793a52dc5d7a75e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692eacefd7d5fc09ffaf6cb6fff21e59641c6ae58719b36e353eefb37ce23580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab7129ae744b86211576634ffd43d0bda7c60bdf3f15b0900f402ab3298cf3ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7d8f6e111233c4b9d634a4ed422f8d4a6aa5da5d47d47ed7330d929dc42a0f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b74470b1ca843389580fbbf5e36e45a81eb8539eb365deab896babd7c88a4f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe195186d756009c713e47069ff033bc13b1c4eadb75160af60530fca45d3e8e"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end