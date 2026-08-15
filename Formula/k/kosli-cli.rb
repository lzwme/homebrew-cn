class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.6.tar.gz"
  sha256 "ed6fe02abd63b9b8679a83f3a7e60bb265fd483e528eeafb9e41370724beda34"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "678ed2b9082e2c624b99432775848a9f489507b82a82436dbc9d38b52b1a266c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b27155232d1e4b8d7bce8c5da534ef77fcc7c3c980f36d70224f824e90688ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e08d867f3f624fab2056149ff74526581683aae2edbfc376689ab970db16f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "afe2e7ff1aa853435a1410d1c17dd37199f38697aa721f04d7228852edadb7b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dcc7343effa59988f561f02cab9b9c9d8b3c338c46f589239fc18981c866805"
    sha256 cellar: :any,                 x86_64_linux:  "766fa19ddd3f6aca6392f8d36b31c6b2454f4d608c44b9bd01dfb6679daffa3a"
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