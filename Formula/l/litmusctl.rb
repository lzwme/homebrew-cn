class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https:litmuschaos.io"
  url "https:github.comlitmuschaoslitmusctlarchiverefstags1.8.0.tar.gz"
  sha256 "365b2c03da5545dffe091b99cd1b073ee06d7fd20aadb528c35aa8362053dcf3"
  license "Apache-2.0"
  head "https:github.comlitmuschaoslitmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df978efcb025d0e08830665221caa5294f33516dbd572fcbeb886a963ff3bd5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f049eaa2907149b5347f5e8c8fb036fb5abfde4e0c9e0331aff5ca8578295ae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73b813461f7375d05981a6e150cdf164c7b0d3f054511374661ff5b6f180faf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7066ff58c954bda7aea1d93024835177c86e99f674a85e91fa1af4fcd1b4868c"
    sha256 cellar: :any_skip_relocation, ventura:        "807d6d3cfc259e2326677f0965c835cc22cee46030c9373d092b7b1e24e0b339"
    sha256 cellar: :any_skip_relocation, monterey:       "59a3c624bbb0a728c4aeab51d83e80df9b321afa13a8d0672480fa2c782b0230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31cc8998a1db12a4fd96b36f77722c83077fdcfead01e3a8286cda6fb27c13d3"
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