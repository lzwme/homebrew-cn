class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "76e2be8f66658885ef6bb2def9b4b2950a9a62a8b0dd0c73ce19295d60cf78b9"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abc05b949b18d9ab69200e4ca5e5531004cd5800363426ecf5dfd8f569dd8b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae6c8244fbba1f9d70f844a0b1aba3d1dfefaca642f8cf2bf9ace511345a18f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea8eead193df3d0f6a6133ac721daf432bc4c9945826b5623da0b10be71dd4ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c28fa4f2e05a54df58eb9af935fd5e54ad9fac3e785f5b1148852c0e99e25cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098f80b02b7ea0adeeed62306aecf3be2852de1b4987e38c6ea879244b822ac8"
    sha256 cellar: :any,                 x86_64_linux:  "970ca4d82d018eeef66bad1b6f8516d6a6a9588a190b48f2fe81bc3c16158118"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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