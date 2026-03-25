class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://ghfast.top/https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "d095d2af4683673806829cccd925a6c51ffe943a9a138e56393aa3d7cd1a2b5d"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a8f8da50639a768eaf9acf419c363c90f0faa48176c208252f551ed0ed10f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc0da7a3be395b6a6be07e5c813e119cbc07bc517eb8af37b449af3c130307d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c73ab8df786d465ead8cab9a772b4d368bb09e25a637c958b7374ca97bd3352"
    sha256 cellar: :any_skip_relocation, sonoma:        "626474349bf993bea0b390b32224e89595b335b960eb723fe75bda95866b2366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2026161ef1bfb1d496d7de94c12997f268c040a59be7ac073f5188e94faab727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b65e3a353633809a3193ed0894ae8b9863e1218386b6b6e6d42d4880e8e75a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
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