class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://ghfast.top/https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "f14099189b5d0296c990824ebb178573072b34c13b938051810dc991ce08ac10"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e8fe1a7b6fd4c920e9e2abc70cb13ca68b125f1e49a8ec92295cc35ab9d5dd8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f3ab58c9407c51aecdc400e7638645c1d8ba08741045aa6206e54ac7b6e3be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6dee12b5fa52c4e9c22ccb1baa31028815a850186136311fba06870aa317ed42"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "457d9628e6754af0e8ee0ba29cd05706ebd7fbc81a69d4cbe0d63200fcaf61ac"
    sha256 cellar: :any,                 x86_64_linux:      "bb799558c4fdd51dbb9c9138ad3e7c3d89f09ca94de2c01deef09ad1fdbdc182"
  end

  depends_on "go" => :build

  conflicts_with "bkt", because: "both install `bkt` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=#{version}
      -X github.com/avivsinai/bitbucket-cli/internal/build.dateFromLdflags=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bkt"), "./cmd/bkt"
    generate_completions_from_executable(bin/"bkt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkt --version")
    assert_match "No contexts configured", shell_output("#{bin}/bkt context list")
    assert_match "no active context", shell_output("#{bin}/bkt repo list 2>&1", 1)
  end
end