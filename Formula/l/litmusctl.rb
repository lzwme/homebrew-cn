class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https:litmuschaos.io"
  url "https:github.comlitmuschaoslitmusctlarchiverefstags1.12.0.tar.gz"
  sha256 "5193ecb7127991e4fe1cb1175ea0bd6f3d376f7fa42f213173fe3724113e772a"
  license "Apache-2.0"
  head "https:github.comlitmuschaoslitmusctl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea16070e81aafd4e9bbd3e5e578d81089360c4026d8bc2256f7f726ffc2be9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea16070e81aafd4e9bbd3e5e578d81089360c4026d8bc2256f7f726ffc2be9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ea16070e81aafd4e9bbd3e5e578d81089360c4026d8bc2256f7f726ffc2be9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98f10ad262809aca35e1a2bbbc4ff2e270f7c621521d55227bb40a33d1023f6"
    sha256 cellar: :any_skip_relocation, ventura:       "a98f10ad262809aca35e1a2bbbc4ff2e270f7c621521d55227bb40a33d1023f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c288364c922e490fa75a1e28d051c55d8d960405cc22496d8914ec8ca8cef1c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"litmusctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}litmusctl version")

    # add the config file in the main directory
    (testpath".litmusconfig").write <<~EOS
      accounts:
      - users:
        - expires_in: "1705404092"
          token: faketoken
          username: admin
        endpoint: testEndpoint:test
        serverEndpoint: testServerEndpoint:test
      apiVersion: v1
      current-account: http:192.168.49.2:30186
      current-user: admin
      kind: Config
    EOS

    output_endpoint = shell_output("#{bin}litmusctl config get-accounts")
    assert_match "testEndpoint:test", output_endpoint

    output_user = shell_output("#{bin}litmusctl config use-account --endpoint=something --username=something", 1)
    assert_match "Account not exists", output_user
  end
end