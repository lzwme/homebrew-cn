class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.46.2.tar.gz"
    sha256 "bbb8f983a3e7a5646bd049bf43818f09d2d8b3cd7ee38dc02e76e9b14a07081d"

    # Fix module versions that reference non-existent pseudo-versions
    patch do
      url "https://github.com/thomaspoignant/go-feature-flag/commit/c8b0b25970eee8a32b7782bc02cac3bd29247a0d.patch?full_index=1"
      sha256 "b9d6531438e9a73a8072c3bf1526c5e81cf9777d4bfa123cb28dacc6f956ff65"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c766fd1cb2bf0e2a29a802a5c1a741994e3faf4f55304157ef84fc896f48e0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0910b6c6f1b057926ef49d4d6c6d29cbfb97d6f5bc7e40094c2f359415db328e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edef828412c19f8abb140cd0e5a4eef1961c2d3c7196366a76f4a4892095a626"
    sha256 cellar: :any_skip_relocation, sonoma:        "2db22d155f5f71ff4b2eb30ffc3868707e55c055e8e6841b8cd32a6736bdd60d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb6ec6589a25d6fa81835fa84abaa78ef825bcc9908c2943e98a1ed2c22bb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d468ff650084cfdca212e7a60422a8052651fdd80b720e3de367e1159b96d43"
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

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end