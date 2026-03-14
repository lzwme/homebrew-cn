class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "fb9a7cfdcee3911cbc9981e3b03477c6a9ef1ec19b2504fd27f01408d81dc863"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c3792dc129170d571ec63085d1162d825bd030c1462347e84d146add7d17382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53930e4c0f32e16afd9099b5e43f2ceec8b45493f6e935dcee77559250091c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82e5137323547b0a311abc2a847ba0a8e04a36f66301f1683662f33c7d4b5ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b299d6ffa2b8d21440e87d9811c58fa37419b181f426b2a9a332ff2372c1d533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dc9d8c8780e1a54ea295b1e910cbe7a62dd11ab8eb648ee7ddb923a1011ef1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "024058068a55831bed48c5e1ba4eb69743097bfead3533cbfbcde264b9844e35"
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