class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.40.tar.gz"
  sha256 "1b1e1e5bbf5bf08207772f6be9d7ece39c1e2121c0315b019e6b36ae04da4398"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9351a01fa37e92ef75400f20d02f60e19122f1d667af94f7707c60aa336d3e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b28ca02a2bcaa5642296331cada2d31ae3eb829dddcf803f0459bd70c3f7f57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c0f1987514f6d13390af5558d823617f0b2a69febab9b9c0d9c79d0876acea"
    sha256 cellar: :any_skip_relocation, sonoma:        "d154d7f9f28ae615dd3c87ab81d9176236bf34776500a9d17e0c364dabbfd035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe57a259a26b4f1752e34421b3df93cffaa850cbb6e67c311f6750524241fe6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6cca14d1f57c8ba86e9e0e36b28102d7be2d85538fbf963a835d9743788811"
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