class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "1257db6397b031ed84ea86645f9c511e737a593429d4d0fc2c82621da6ef9871"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e151a7265105e51a6e74619ca67adea37792346f4c0ad18d3ae99ec39415dc2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "568a5f2a4f86599e9962f412b24a4e8bfd1326e98ca42bfe36301880d422ae7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c23e4447cf919a9e93664ac510f9356ec99c377f2e8d20418aba094d26ef7cff"
    sha256 cellar: :any_skip_relocation, sonoma:        "5528051c6badabe755163fb2e6581c5c8a9da0f24a6178358f1d38f873bbaf0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac2d428015b66ba5794aa2558fbbfc28c3d4fecdc09967f8bbcbe45ecc8b38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea488ff93711db7aef0adeeb06be7b4c08979b315475a87b81ce3586d5f6d30d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end