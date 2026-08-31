class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "ef4e9e9470402ddf96710817c2096e307e0da66ebadbc9083165707ce63330e2"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63630d7bb37d2e6b9f689b47d18de4ecaae62d01ab891f69736f55f6ff9bcbf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd0e28c4637ab971a5287c9b362a561fab123724d9ba71ff13966d44c33686f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0980413bd210205a7a71c8559ac251a85ae18903cb9e271a1f402187498ebf4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f080e3f82054ee5e7e2aa0a4105771eb56c581a008943302a986efeae552286"
    sha256 cellar: :any,                 x86_64_linux:  "67f97613e293521b0da56c4ac2aaccc6d506cbf5db68a288cdf97feb5c0683be"
  end

  depends_on "go" => :build

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