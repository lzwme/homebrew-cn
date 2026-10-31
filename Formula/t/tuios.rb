class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2d1e177e5e6c500acd1a2833cc28677bd659f036bb15f96a869fb1cc13770140"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8461b16c4803cc51134224dcda2399a704b3836c3ad490a1ba9d59e9edfc8b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ccef1b0b151553650b45257517e65c02523ebc4e71af81971a94bcdec552f10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6abf2893e17911a809ae2dedd8252a223622d4ee78191fa60091990c064d9f59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddae47c42c42abdd87a4992d64cc03843980902a9dfc803a43eeb7f91abdf6f7"
    sha256 cellar: :any,                 x86_64_linux:      "88ae1a920c0bf0438da3c6a022040783f7ad916f2b4ce4dd12cd4273bd0cda2f"
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