class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.46.2.tar.gz"
  sha256 "9d1f73601d894442cf32641b233baf24d73ea380f32548e7d908859e635a25a5"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d114c6263e30fe4dfe28cb6e2b6d255ba7c9635c2fae42522b4119ba4efb5d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "765e41d7ec8483e761bbaaf0a7188ebdd9ca9e766e2fd195a37a4401de210b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95ecbf4e173b8fd715fc0540214734a1fe55113790232c00d4ae2f7edb70b6c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2434b02eedc6a856913b26c78cee96aaa49fd56da82039ccbf75b7698747a69"
    sha256 cellar: :any,                 x86_64_linux:      "3ade106e1121237ae9da03d664a3524d531cd022d085d92c40077fd4720e955a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end