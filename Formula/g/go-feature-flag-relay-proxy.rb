class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https:gofeatureflag.org"
  url "https:github.comthomaspoignantgo-feature-flagarchiverefstagsv1.29.0.tar.gz"
  sha256 "1d01d7d2c5bfd7b26ae7e3112af6e0f7413539d379f5332afcff597c497fa791"
  license "MIT"
  head "https:github.comthomaspoignantgo-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "466dde9e5ba6251bca5f6cd939ee14a3d7f17cb39ad01f1120a8e50ab737ce36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f14e1f8f090b1e0f7c2ba4a1a532877db5bbcb435ef0d406bdc68d852430bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b263ca3e034ca0c7a9c167ab48c5b2780e336cd2bfbd7482a52a9cdb7bd548"
    sha256 cellar: :any_skip_relocation, sonoma:         "54014f27cf5361ca258c2679d5b3c37738cac96a492c7fcb2b1e3a1299853bc5"
    sha256 cellar: :any_skip_relocation, ventura:        "88100eb0a9f6ae3bf649555fb8f939e5ffc3a29d97862524aeb91f6487f0868b"
    sha256 cellar: :any_skip_relocation, monterey:       "2d9bbbb8d9d8acc98875a649fdcb086e09ec08fab0cd5b0724268f9cca2beaec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60aea8dd1ecac1c53a05c18e303bae112ce500ead6b9092b7880f94f83866ed"
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