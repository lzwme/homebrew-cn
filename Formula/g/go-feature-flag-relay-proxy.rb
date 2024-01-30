class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.22.0.tar.gz"
  sha256 "7ac92f0bf6f79f32388e0622895002d452ad6001fe91dfb2a834b7200e410420"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc1928b91f05b7ce9ca0354df18e9bf0c351251c844cca68341090745c21a64a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c312753d5ebde1cae24acae0840c13396d3392ec1b1698c5dfdf646de418df3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e70f5c8b391a311adf69556de50e00b5f6c14e7217968afd05e522c3dffc4c37"
    sha256 cellar: :any_skip_relocation, sonoma:         "10d0fbd6588a4852240a075e83d62142bd93888d704f0f47420c4729c0bedf40"
    sha256 cellar: :any_skip_relocation, ventura:        "0dcdf8b6ff5ebf32ea8c76b01b16ddd071a2a0b51ec738e0564574ba7a24e9be"
    sha256 cellar: :any_skip_relocation, monterey:       "db40a0179dbf352489a9d60d27fe6e20dbbdfcb10db3c45afd1605b552f1c437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1178b906389b6feffc853871827dbe0f3f6d8c784bd88101e1c57bb04745e919"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdrelayproxy"
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
      sleep 3

      expected_output = true

      assert_match expected_output, shell_output("curl -s http:localhost:#{port}health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end