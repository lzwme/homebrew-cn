class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.17.0.tar.gz"
    sha256 "f2820fa3be70d44f469b1ff7280e6517e17766e248fb117e5f5e5499cab20429"

    # Patch go1.21 build
    # Upstream PR ref, https://github.com/thomaspoignant/go-feature-flag/pull/1208
    patch do
      url "https://github.com/thomaspoignant/go-feature-flag/commit/dc834ae368b50280aebda88eb609b4a4bce084d6.patch?full_index=1"
      sha256 "64936b7b17c3730d6ca8e4946ceedbf574a9d23c5789692f5ee0b03437e43699"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2544ebede7fd8380d492c8767b21c6883917a740e177ea14c54f2860c2b7a34e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24e62ce202e12fd33fdafd22bf3ecf6d42f8d9b760030f2a6b810589735a20a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac0d8291641d0a9792ec8148a618145de6e618568f0d7bc50cae740d5640e15f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd78bfb5f19eba4a1eee4639c8287683955769f1443c3ee0774221492f8ed11f"
    sha256 cellar: :any_skip_relocation, ventura:        "91fd405a5def64aee0f83384e7f8577044815cbb3486ac7cdd33072f7d0262cc"
    sha256 cellar: :any_skip_relocation, monterey:       "cda55b989990e906a3682b62c2c4082709d3bf39d3467be43b23683957f6b104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21bcb5d915a46f6918a20744a5e945d6798982d7e3672d9a327efc06786bdc5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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