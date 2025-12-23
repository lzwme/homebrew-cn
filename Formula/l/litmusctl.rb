class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://ghfast.top/https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.21.0.tar.gz"
  sha256 "40bab734aeb96c0bf75a05d3c020f65001c7aad3884fb93ac464317d9437cc19"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a05e27ff15de6f9102a1edd11eb69186af98f550321b5876ed469df5cbf6fe79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a05e27ff15de6f9102a1edd11eb69186af98f550321b5876ed469df5cbf6fe79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a05e27ff15de6f9102a1edd11eb69186af98f550321b5876ed469df5cbf6fe79"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b20a4a3ace2f8f21378c015c939dc2e6249d91226308a71b7abb1ae2189406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d0058eab50266ba776cf4de6e16d3cd1735fcfa5fdd4422f004bfc933cf21ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a480ad4724ab34499e5f5b5c7753b2a4a684b2c5e0502dff9c4b78579f001770"
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