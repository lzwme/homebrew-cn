class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https:github.comhelmchart-testing"
  url "https:github.comhelmchart-testing.git",
      tag:      "v3.11.0",
      revision: "a2ecd82b650c223a8d264920fd0bab40de16b915"
  license "Apache-2.0"
  head "https:github.comhelmchart-testing.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d4e9f3793ec9372a52ea52abb84aeef2bf3c09c5944b0b234fafcd8686c81a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d4e9f3793ec9372a52ea52abb84aeef2bf3c09c5944b0b234fafcd8686c81a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d4e9f3793ec9372a52ea52abb84aeef2bf3c09c5944b0b234fafcd8686c81a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "31021c561345395d78a27206edf36aea05aff471f0d27ddebe5c414a29f6024b"
    sha256 cellar: :any_skip_relocation, ventura:       "31021c561345395d78a27206edf36aea05aff471f0d27ddebe5c414a29f6024b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44181e774cb54239747801964aebf3b2e122d275bca177e1f753392da6a73a65"
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test
  depends_on "yamale"

  conflicts_with "coreos-ct", because: "both install `ct` binaries"

  def install
    # Fix default search path for configuration files, needed for ARM
    inreplace "pkgconfigconfig.go", "usrlocaletc", etc
    ldflags = %W[
      -s -w
      -X github.comhelmchart-testingv#{version.major}ctcmd.Version=#{version}
      -X github.comhelmchart-testingv#{version.major}ctcmd.GitCommit=#{Utils.git_head}
      -X github.comhelmchart-testingv#{version.major}ctcmd.BuildDate=#{time.strftime("%F")}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"ct"), ".ct"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}ct --help")
    assert_match(Version:\s+#{version}, shell_output("#{bin}ct version"))

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}ct lint --charts .testchart --validate-chart-schema=false " \
                          "--validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end