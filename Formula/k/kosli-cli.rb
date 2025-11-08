class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.29.tar.gz"
  sha256 "4c263739d5b02cc866b96a50a640e6543e7010d1cb50ad50e51c7cb4424fd73d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebf45f6244b2e50f91701c46d8dbbe2f28c6f6f3da0c74857fdca9296b25e903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0bf5457ebc35e1d9e32b7ef52d1bb4743f7c06597165a395b468c1657d1959d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1efa38e5dc7d10d2dc49d5b19b9ca3b1f5a938e5cb3bf78cb9cc5387a5ccfb6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b53900d9c5a444e62a2c448dd26b7ddb2c520ef2ff0c8bb6c5d8294bb5ff984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d229140dc4307cfd7e4f320c6221bd0cfa4fb9cec8ae4a662a75b7155f32deaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6372efa546b3262008a3a291bbbc2b6c4dd448e2dabedd1c821fce252ccb206e"
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

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end