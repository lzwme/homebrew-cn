class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "5fd6cff1e717385d2836ecdcb4e2f7faf01df846e3256c46aacd79e1dfd883f5"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86594456bd1495fbfdd4f776daf6e5eb6e4d2d504e1babf901d72d9464692b9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8665e0e315cf95f1fe9539dda31ab9fb0e38f2accebb52d184a73f590ea86d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5276d14f58647e85a5e3040ae5d08766afd18e9a6002dc3fdde943acd99d70f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7e2ccb88e33cc6824766b9843e812b341f6b5cc503a368c4955726b56d380f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ca8ba91e33065d7b38b64d79f22a47d161764390557a9ba543ad14f71ae4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd546f6008357d47bfa5dde5d35235f202d9588a728188a3b585c2f00c974bd3"
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