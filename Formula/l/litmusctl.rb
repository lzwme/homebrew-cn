class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https:litmuschaos.io"
  url "https:github.comlitmuschaoslitmusctlarchiverefstags1.12.0.tar.gz"
  sha256 "5193ecb7127991e4fe1cb1175ea0bd6f3d376f7fa42f213173fe3724113e772a"
  license "Apache-2.0"
  head "https:github.comlitmuschaoslitmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a44f01ab6828433fb6aa72450dd29a710d20d6304553330e4a4c281e0d4e0d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a44f01ab6828433fb6aa72450dd29a710d20d6304553330e4a4c281e0d4e0d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a44f01ab6828433fb6aa72450dd29a710d20d6304553330e4a4c281e0d4e0d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a93b3080ee63aeb0d5afa97e2cd8ac633afdbba4d7e809e138645f22f4470afa"
    sha256 cellar: :any_skip_relocation, ventura:       "a93b3080ee63aeb0d5afa97e2cd8ac633afdbba4d7e809e138645f22f4470afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a06bffa7b08469aaeff0dfaabf580125108fe9be988575adf65f495e020782b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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