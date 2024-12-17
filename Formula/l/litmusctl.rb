class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https:litmuschaos.io"
  url "https:github.comlitmuschaoslitmusctlarchiverefstags1.13.0.tar.gz"
  sha256 "b23e39085a0c9ea20c1fc1aaed1bcbe83c7971780411f098f2fa08061c060e41"
  license "Apache-2.0"
  head "https:github.comlitmuschaoslitmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329e71753e085ea224fb8a3ad91aa63f03502590f1c4b5a9c539cfd7cf88f5c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "329e71753e085ea224fb8a3ad91aa63f03502590f1c4b5a9c539cfd7cf88f5c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "329e71753e085ea224fb8a3ad91aa63f03502590f1c4b5a9c539cfd7cf88f5c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb5c24fc54edb506d027bfd734760a843d42983665b4acf4ad25928f4fe06ff6"
    sha256 cellar: :any_skip_relocation, ventura:       "eb5c24fc54edb506d027bfd734760a843d42983665b4acf4ad25928f4fe06ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc4d33eb7b1ae4f0ba0476e559019a528e4f5109930738151ee89fa914f24cd"
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