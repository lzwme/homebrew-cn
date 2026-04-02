class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "205515829dabc6c312e33bcfdb7f069d4c23da46e4a90f977e39466ccb150cee"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd0cf973e17c8271d2de7d638dbb458f288f29dd78e62f041ba04d612a464cd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92fd3f2bf0b3571d0783e3800f2fba733131747c9b7a33d1762db34252e07186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c24945f6993367dbb6d6360e72324be832c9ba5693cb6f6158fbfbe6a8d47586"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca5fdd48f2a233ddcb609a4ed9e0bdbb9c1ae9343214aadbad91bb879fa901ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c97e9051d93c9d80354d4add656d7b5798382b895c9796cda6895e8d3642d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf9bc81a884622de1bbcf9c307637be2ae3b06bc8a4e37819e24d878aaa66297"
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