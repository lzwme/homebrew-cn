class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "b76e6d6db9950f5228ea276b8a8524c55a754ec5ac50b982fe82af6b3d249a3c"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25f3cb005a1894d1595adcae4bc837667955677a60ceeb2a747a5e168175c426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a83df182a9d6654f03d5974c2c9e7e7eaa52beefe62c1a68b0944a1867779174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a32d6c98ac93e9d6ab29ab7ef96ee947281298ecec0a81acad85690de559fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fbb8fc02ce54488924aa73ca994c7a4f5015a46fc65e5680df5efc2e2b9fc9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6b50e8a25bd9bdb68567d5d95d23019723b2f7ab5d03b949e0f324bb5b8704f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea6891f0959f0c061fe72c5cba368c66b101fe1b5da36c4d648e8afe8c0a004"
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