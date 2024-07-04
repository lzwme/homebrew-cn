class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.31.0.tar.gz"
  sha256 "c0ec59618b406b20423eff9e608be29baff3b42320929aadc4f435c88d342d81"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6362451ceb87fa0d741870c51c09e923e6e6772496ec38281b465ccc5116a4b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9235ea69f84ca54b335da147665990b0de75a18b81afd0a404d47cd8b032661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4921b215d877ae0d6606d7ee7acc9b257a67d45cba74e0e208fa35dacd23e06d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca3ccc012467522f3d700a066f2ede6223dc5a72bb92dd623f27b68e6dd35b0c"
    sha256 cellar: :any_skip_relocation, ventura:        "04765a56401e25f156625329b220baef4911c7e6752ab8b6766cdb9dc3421900"
    sha256 cellar: :any_skip_relocation, monterey:       "ec877f4f9bc9b6a3cec8e1f8ae2f2102f8406cbce6ded688483f9e09b58ca4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63efe02f08793c45c23e98e2a7b93f3262116f13be0ad93122b2ae47e57a5acc"
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