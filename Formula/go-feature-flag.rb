class GoFeatureFlag < Formula
  desc "Simple, complete, and lightweight feature flag solution"
  homepage "https://gofeatureflag.org"
  url "https://ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "e2f263086772c49d835b0dc0f0a12e66dd0691016c3b1d8248ce70a15d44d526"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc680d6ee16022391dc99cbc4cb1fdf938af3038660856edc155ef5e3cc541a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc680d6ee16022391dc99cbc4cb1fdf938af3038660856edc155ef5e3cc541a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc680d6ee16022391dc99cbc4cb1fdf938af3038660856edc155ef5e3cc541a5"
    sha256 cellar: :any_skip_relocation, ventura:        "1179dda8f6b391cc30fa4d2f3da3526d8e67aee448ea66c5903f42c0c34fb631"
    sha256 cellar: :any_skip_relocation, monterey:       "1179dda8f6b391cc30fa4d2f3da3526d8e67aee448ea66c5903f42c0c34fb631"
    sha256 cellar: :any_skip_relocation, big_sur:        "1179dda8f6b391cc30fa4d2f3da3526d8e67aee448ea66c5903f42c0c34fb631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1d1773d831384dae77c0908fa075474c34ee1b6e860000181951e066147b37"
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
        exec bin/"go-feature-flag", "--config", "#{testpath}/test.yml"
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