class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a3e30b56ad0b299fcd94eac3b79cab528d46a56d35a09af3a191398c0d6afc90"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bea9bbfcb7abb07cd076301b07eaa5bc8117c9701fbde9e5ab94c574f61b070b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "acc72601829e35f247bf5903697efdd759da8bf091828fd13714e9cef51b01af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6def8fc62b75cc43a60eea59869d0490261ed3cb4e2521f7beae3b070964389"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4119f6d2cdbb9eb0355ed3834fe0d75836f1df1bf00dbc4c9e3f68bbffcf29b1"
    sha256 cellar: :any,                 x86_64_linux:      "37d523ba203cb54aa0b18d5213db1deba58d11655dea6df8537191f1c810c697"
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