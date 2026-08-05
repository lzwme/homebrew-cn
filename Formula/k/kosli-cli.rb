class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.5.tar.gz"
  sha256 "e5da4f2e49b25f2a823476cbe3c50eb0925fc9dc1aec6b7cd94b16e44546e827"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "470d35b3eb3ba96537574471dd126596fdc58e7fe999a695155a31edd7d7631b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5555353125116ef16559770f128a96b1620aad560262d0cf1a38f18f7900e00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d30fd6d7ffc6f8c4e38c31eda4332d5c15f68c93a31a03c040bb5466bcfc748"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdb694f33d99b93f8d89676418ed29db3b32b6b569033391a074658cc08f6f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "971406da9d25e520ea5b8ceb6941285436a5d1b96fd1fd0c34603fba621748de"
    sha256 cellar: :any,                 x86_64_linux:  "4f0b82fc7e063cfeba6637a85d5f00d8681afd4e8a1dd672c05dfe30f35a5174"
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