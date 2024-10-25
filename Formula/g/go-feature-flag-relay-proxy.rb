class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.37.0.tar.gz"
  sha256 "a4ace566b147ba4fb2a358efa302129240c1b11ee7d6d3cb0cead7e5b4fa22a5"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3242b1a5942f13ec9e55ca10a6051b1856c29533e79916350cdbf2db294b436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3242b1a5942f13ec9e55ca10a6051b1856c29533e79916350cdbf2db294b436"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3242b1a5942f13ec9e55ca10a6051b1856c29533e79916350cdbf2db294b436"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4e065089c5494f40cce740a70b553880aa72026f19f2a47926b873c6edd132"
    sha256 cellar: :any_skip_relocation, ventura:       "ef4e065089c5494f40cce740a70b553880aa72026f19f2a47926b873c6edd132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88d9607f8ce63c0eebd0ec674015538b3874f1e784fea5af9319a3e1c366f942"
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