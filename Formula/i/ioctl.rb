class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://ghfast.top/https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "6da30b5319c303e87ea14dd7804a78ccc44f099b3607375eeb71afe9ca38a96a"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "312ad7b47bc980a90d127529a1e8b515c66e5e1723820fc31b01f0ff59a8fbaf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e263479512b263fe1b5ff536599aa32b3aa41d232f8a2b887de2f588adc7cfe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8ca25c0bcb26297c95b2ffd2ac5be1a677fdf34b15412d22d5765acd4c9d922"
    sha256 cellar: :any,                 arm64_linux:       "ca2a05f410a749c099598e4d30e122dae23f51132dc71c3107e6a5c068bcacef"
    sha256 cellar: :any,                 x86_64_linux:      "ab73db3567fb3616ce2e2f15b2fc5229de8f789f690ecb23f1d41c04d0f436f6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageVersion=#{version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageCommitID=#{tap.user}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GitStatus=clean
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GoVersion=#{Formula["go"].version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "nosilkworm"), "./tools/ioctl"

    generate_completions_from_executable(bin/"ioctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ioctl version")

    output = shell_output("#{bin}/ioctl config set endpoint api.iotex.one:443")
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end