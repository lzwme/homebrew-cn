class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "0cd4fb308cd333028b20d762e77b02c155fa977bee69c9d570c54cb98284a022"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "234a7e3137a6a25297ec66f0a2a443c91d9d1a31f0eaf20eba2529f6facf901a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27ea25fee9907f876891c65f9218deb47c644b686f4dd57add2f8825d3774684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "090f3026fa24dda7287b06072e57fe178d61d00ec2169455841c49bd2a2c0458"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b9ab7208f87a561d20ebfba381871d8889af4ca50238d9334448c044420c32e"
    sha256 cellar: :any,                 x86_64_linux:      "761170739ca799ce6c177493202252d5967a44e963330d88d841cc3e059ac63c"
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