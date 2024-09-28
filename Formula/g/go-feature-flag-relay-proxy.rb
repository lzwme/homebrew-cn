class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.35.0.tar.gz"
  sha256 "ec71f6457e83c85aa1758a276a66cd1b6d3ac9df746b61712830368c82351946"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecaab3985d9aa10d4bf817daa1b2226c3d6f2c5496cff0335da4cde5b20e8b5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecaab3985d9aa10d4bf817daa1b2226c3d6f2c5496cff0335da4cde5b20e8b5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecaab3985d9aa10d4bf817daa1b2226c3d6f2c5496cff0335da4cde5b20e8b5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "27e23c1af9b308899827f2ad6f399e093aa2c5cca255963a11de2f50ed1d277c"
    sha256 cellar: :any_skip_relocation, ventura:       "27e23c1af9b308899827f2ad6f399e093aa2c5cca255963a11de2f50ed1d277c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a731676280f0f52feae7339c16cd83c99490573e7064fdc991527e65f44cfec1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdrelayproxy"
  end

  test do
    port = free_port

    (testpath"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}flags.yml
    EOS

    begin
      pid = fork do
        exec bin"go-feature-flag-relay-proxy", "--config", "#{testpath}test.yml"
      end
      sleep 10

      expected_output = true

      assert_match expected_output, shell_output("curl -s http:localhost:#{port}health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end