class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "340e111349ecfaca42c7ebe7f2b6d3aab8b929750613d86504d5e948420953c1"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcf13e1176e65eb8a6da7ceb3da9e85fb57ebd89c42e06cc6aa2f9ce1e77379e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b40fb4ed871f3a868df90d2ba1930ee0111eb11610931b8431bb67a04a95aa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fac0c8f457ae2927b5869ac61971eae9e2c9f4cfe4949f1ee15dec92cc756f6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db7374c09106873eb8a329a0bf4364b34ded56490fb11d9f05cbccea7babd798"
    sha256 cellar: :any,                 x86_64_linux:      "3ac4bc6eb44a5147d4ad063dacb0445e7ae20011f5105f2208eeb545f3778d5f"
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