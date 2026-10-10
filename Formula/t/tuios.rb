class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "d2016586cea908eb094bfa175c233109626852f6b317231f1db284fa53783974"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7070f3c9a026216b345660d671406c062358c7a607215338834e8f1efa0f8287"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d40b5ef9f2bf442bde56e7d3fe5ce5081f7ce75c0b2b994c13ff03d03ba84b15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "962d71c3830d56cb984ad9d722e1366c4ea093837bfbf0b573099a93040e066f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5531844e166de536b4c53f048fe03f98107b29df4dbcec37e95be8a335dc0cac"
    sha256 cellar: :any,                 x86_64_linux:      "abf7653df4e350a327af15706e7e2e84866a871bba629d30dbab9176f1faa0d9"
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