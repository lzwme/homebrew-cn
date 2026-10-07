class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "f76ee562c787420edcf38fe7a9a33731fc3f00a008ede47edd4806d2d21a6238"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c75e2c27ca1da403ff0c4d66867f81b3aeb0c37c09eb7a4ac322bcd78b81e958"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad6144fffb97f34d7be9ed509f1f330cb3b5721dec99aaa667e22e5fe51e94ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0723e6ded547f5616fd6629298939fec10d11b733ae870757ff1996a7809e29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66a01b7d86ffbd543425db1e14f8a05e7ee934c85ba94e294ff330a694a020f1"
    sha256 cellar: :any,                 x86_64_linux:      "5f596879995a706ab52aff9d07d9662d93413b036b0229cc272a80905d1868b8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end