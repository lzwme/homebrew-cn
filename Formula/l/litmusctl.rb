class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://ghfast.top/https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.19.0.tar.gz"
  sha256 "741df202899471bf5d9b282d99380f47a3ac197c048ac3483de459dcc5c50192"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d9032e38d35e47795478a009dcd3d87f77b3cd2c9e0592a9cb765571759c155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9032e38d35e47795478a009dcd3d87f77b3cd2c9e0592a9cb765571759c155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9032e38d35e47795478a009dcd3d87f77b3cd2c9e0592a9cb765571759c155"
    sha256 cellar: :any_skip_relocation, sonoma:        "14370af5cee1c3736a04661f16b757d9437255c2349361946b9b9d145ec46396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0135f8a383e71677c148503bfc2031317a4cd58a0b9ad209707ce98ba8fdbaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51b1e92efafdec2970ca8110cd6f4e488997fe7b98539616cdf89e9135f5933"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"litmusctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litmusctl version")

    # add the config file in the main directory
    (testpath/".litmusconfig").write <<~EOS
      accounts:
      - users:
        - expires_in: "1705404092"
          token: faketoken
          username: admin
        endpoint: testEndpoint:test
        serverEndpoint: testServerEndpoint:test
      apiVersion: v1
      current-account: http://192.168.49.2:30186
      current-user: admin
      kind: Config
    EOS

    output_endpoint = shell_output("#{bin}/litmusctl config get-accounts")
    assert_match "testEndpoint:test", output_endpoint

    output_user = shell_output("#{bin}/litmusctl config use-account --endpoint=something --username=something", 1)
    assert_match "Account not exists", output_user
  end
end