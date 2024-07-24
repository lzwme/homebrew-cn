class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.31.2.tar.gz"
  sha256 "1f9d1b6fad874722eb152414587abd97891f3974bc624d98355ed20325486180"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "802c8930c4976a82e5e40d97ee9965db6d6c8d47d386ba5d2cbf3b155357701f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f932bf813bde3bef0c93465d0eac39da38b1d44bc39809f7a1ed8db2c6c050f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abe00ee8aa4128648fc45ecc7c61712f2032fcfc729bc4a1c8b60a4bf47d9334"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ac0b426b59c03c1c0d37668767c41826d252ce082373f34616cbe1a863b2c60"
    sha256 cellar: :any_skip_relocation, ventura:        "5f93c8d1d6e7573228f24329817037dbc239e9fa4417f0acfc538acd2da32172"
    sha256 cellar: :any_skip_relocation, monterey:       "c0d07712c1f4df8b4f9bfab55c997328880a429655b28bb7e0637bb8b6540936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d1a1a2a74a9b4255cba80af175442a47361247b360efedeed7931db60b43b94"
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