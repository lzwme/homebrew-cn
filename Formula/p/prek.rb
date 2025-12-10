class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.21.tar.gz"
  sha256 "9cb2d55043047cac307eb0f15ef1b5ef491f4626def3e564a67055ba3d74806e"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64c1cdabd45175a94f4af4669fb0597bc87760c9d4cc1322b7b4f2df0040ca22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee4cc73f405d1a9d75bafdb1c4d7a43d1d71665d25c1afec1b3eafd9eeb3ac86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d64c318f29c57b73578699e933983028e0cb5b6824e554d53150460060bf75"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ec2488c09e5fb1cc5c879be54961d19b6b662dde887129597fe26083ec30afc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb4fef24b0eb1e83c2e43f3ce7b05c884c08c9d9b7418c41d0e6c7ac1df07ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f118712e4a6bafcb93dcf0a407fa453db0b742508858e5cba444b67a55e91e84"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end