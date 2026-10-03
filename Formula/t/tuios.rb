class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "db5451cd637ed4fe82064b927061fd9dfec935c5d942fb8a454897d4b56f63f5"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "022aba19592c5c11e76b2e21efa180a7dd2e667615ef7a75908ac016eacd8382"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "734f7aff4d919f1005b59fb8d764b08bf093c87b1974d007426e1ead9cff7c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e0c94293e91be4606c3938706a6751cdbe8821c049443e9f5bcfb1b90793cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "753f6f2e6ca248a8c0fc843ad5f7875fcc80ac72ad2b4000049b64a9b47cb0ee"
    sha256 cellar: :any,                 x86_64_linux:      "284fd9bc0408b4453ed676c4b81eeb34dc43d2798a5831a451e58482dd1f5635"
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