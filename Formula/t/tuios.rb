class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "a083bafc5dd6d73c1d8564ee1b4151541738c26d28467a7b5ebcefeba1c1d057"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e17e53f8e1df63e2efcbb50229e68a32f0bcdfafdc7d058648ea62063face855"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4aab61569a73d19e98e762d3442974a45378cf1e2b7329e9e3198bb4903ca1ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96ef7f4a68601f3334e315e70bc5366f5e070c8f769c5dca4e44cb716fd8f44c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1a71fa2a7ad7f68698e549d2be37a56793e8f90513fbc4edadd941310d86222"
    sha256 cellar: :any,                 x86_64_linux:      "40814144a5c08967ca29102e4f6f430d9a066659006a69bc4735718fa152a92e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end