class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "1af34eb6bf3beb19b73b334f63f77c9225b1c6d57a5bdb53752ad06135843396"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d3d15a80d269cdb93a30e65e06ffc20b25e3c7fa697d0f6b2eb88b57895bab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63638e6575648da6d76a8e5c5a5dfb91faba6baff9735fc53a26bbcb199421ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd4e205963d6bdccac20546526692465d5f244c3656bac3c4d26f9b980bcc73"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a153bdab12874b689edd4ee7ef8aae562c1aa9c3914f4c4c045e997991dc6e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d72178b9841317c1a9b19a3e145f83d4f977b8647a89a210e04543c3c789e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129c045f7543216f3b0faeadf48f266e8b61b2ff969ebbd5f6073cccd90181e7"
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