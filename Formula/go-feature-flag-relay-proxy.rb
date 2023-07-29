class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.13.0",
      revision: "696fa88c11d053b8ed8103070b7f04f3a87a613d"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa4c2136500afa6b56958cb11bb4dfc92a8dbe68235e1914de3b5afb10e57e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa4c2136500afa6b56958cb11bb4dfc92a8dbe68235e1914de3b5afb10e57e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa4c2136500afa6b56958cb11bb4dfc92a8dbe68235e1914de3b5afb10e57e65"
    sha256 cellar: :any_skip_relocation, ventura:        "c4aef1646b2c0e52d594f0fe4faf463a26f8b00ba393a66da48042f12dc02734"
    sha256 cellar: :any_skip_relocation, monterey:       "c4aef1646b2c0e52d594f0fe4faf463a26f8b00ba393a66da48042f12dc02734"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4aef1646b2c0e52d594f0fe4faf463a26f8b00ba393a66da48042f12dc02734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9674960f324d623c8b96cb6b0ba6944fa92b0d89dfc5deb50aa62916384646"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end