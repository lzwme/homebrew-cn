class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.41.1.tar.gz"
  sha256 "d7c365c5cf922af03b683c8650c77b12cd90b67a699083a5833e5bcf19f066c6"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0002e19395de20074198eae7304a9b0705f041b74c2cb5d056b1b4372a2a3a29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0002e19395de20074198eae7304a9b0705f041b74c2cb5d056b1b4372a2a3a29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0002e19395de20074198eae7304a9b0705f041b74c2cb5d056b1b4372a2a3a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e938b97c018c438a2632e4db4b46f82340e9f95b26f699bead8cccf1d50b5b4"
    sha256 cellar: :any_skip_relocation, ventura:       "0e938b97c018c438a2632e4db4b46f82340e9f95b26f699bead8cccf1d50b5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ba16ec82a60975fbdc237be0e60c18388248683b7db0a8275d52b811c7a790"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdrelayproxy"
  end

  test do
    port = free_port

    (testpath"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}flags.yml
    YAML

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