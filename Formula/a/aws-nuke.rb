class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.64.4.tar.gz"
  sha256 "3e4c926e9f9171bf26cbd9be099988369cfd747066a2c4aecf81ee0229469b48"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a1bd30a66528a9799c5f53f2fb814417ce8f7882267b658d65527bc9b1b7c24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a1bd30a66528a9799c5f53f2fb814417ce8f7882267b658d65527bc9b1b7c24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a1bd30a66528a9799c5f53f2fb814417ce8f7882267b658d65527bc9b1b7c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "940807e44dc3dcee8a5cf3c55a780454d24aea823e26b4c8c63de1945878e968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0150d7c6825998e8fffe1d0d4f69e99fe36c0a7464eb75fdce591facf0fc6876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe6fb04613b2ad1feeeda4667e8778842a93c8cd68622b2d5a48819a4885d68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
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