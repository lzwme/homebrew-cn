class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.68.2.tar.gz"
  sha256 "d50b29d6b2f0a90f093b67dc426251576e985405fe0b7468a3fbfcffea5d50ef"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3bf593470082cf702697b38363589fdcbc42004b6191cac012e801daefa96ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3bf593470082cf702697b38363589fdcbc42004b6191cac012e801daefa96ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3bf593470082cf702697b38363589fdcbc42004b6191cac012e801daefa96ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "adf15f9d185d735394c31f6cd97d4a6a868ae6d5bcdee4fcbbd11b2f3c69e2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b931a3bcaf99f1f8140182cb656c0edb529d665e300d6f5046d84da864166d6f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end