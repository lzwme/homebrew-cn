class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://ghfast.top/https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "11e678b0b4375e6adfe85d4bbd549a97b094c2f9cf9615bd9d537e8323c6e893"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04cac29e6064555c6f197a66d6cbe429be45691138e0562a74af9334d0087d6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6adcdfec39a60bfeab21fffd53923a387bd0338936ca063bc69204e669870b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17b607d7cbc5e809e04238a9d995f3c889439a661d2792437697cec2cae3d933"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3326fd6c572aeeb12697e1173f5d5bd477b18f7d481ef109bbdbb8f009c848e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b17e5b0e9385493c7e5438c4ad326dd5c3f032afd1fa9868a38a139f8017eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6034f82f5e1916c46c8d8656ecce3c197dc9149af4813986bdfa78b5b3bd62"
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