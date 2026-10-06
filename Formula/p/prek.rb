class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "a6441e8100fb83f5dedf0fd5db04e403f39a4132decebf2bfda67cd4173d7881"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2550e0f718e62a9a5a399b1b109c3d850715281fc191f42a7992398fabd26d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b766f47e44f3faf18c842a5308caf51014496cbeae089c2de1d49b07f6224b12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca9d48f1bf468c9150a42a505d129fa6a2fff8202975417d7f1e8f655ad7574e"
    sha256 cellar: :any,                 arm64_linux:       "c4365ff436ef2e304dad695467487e86cf2675d86b9d33064facfbcfc77f38c1"
    sha256 cellar: :any,                 x86_64_linux:      "360e7e9453eeb6b50ada98f82548f3c386e780ae65d9151989b8e981ad9fcd97"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://prek.j178.dev for more information", output
  end
end