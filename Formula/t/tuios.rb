class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "27e7d607eb97537066cdbb3ff2ef1f0b7f82abd1ecfca2746ddfd38e52ee25a1"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2cef6d96cb13312ab4035c86ae8775c50110f30483176bc84c0c690d3bacdc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9bdc3c9cffd65045e415ac8976b1ffa2f57ecf19e7c282fd3e47f7cc76e9fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bc17b078ba8dcb4be82b9bc361e3778e8b8a5a2668834f54b158cfff35c3422"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5ec6f1d8c0a1f2cc7680b4e9b8a997715d7783c50766f11ba628f1eaf53931b"
    sha256 cellar: :any,                 x86_64_linux:      "5de13ff5ee85b5930f3d40817586d769c275159e9f445c930dda300924017585"
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