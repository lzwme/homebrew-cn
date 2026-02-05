class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://ghfast.top/https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.53.1.tar.gz"
  sha256 "54391b07f61254eff2e58a78894ec68da702e1583e17fdb75c10b905536d919a"
  license "BSD-2-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "077abb0b7943aedcb4b39adf101b6cb32478cabb2cf91003ddb2a36224fe719b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077abb0b7943aedcb4b39adf101b6cb32478cabb2cf91003ddb2a36224fe719b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "077abb0b7943aedcb4b39adf101b6cb32478cabb2cf91003ddb2a36224fe719b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b66c3a64c5afcbecebb33654b15340f23757daded46038ae6f21a1913d8967d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1f37cdcb6d259a0ce40a75de8245f67f8ab4d6764789aa189c12fbf692a49e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f65839239fb2c10cd7c5a7ef669e91322df86f629d6500fe4c3fa09e8c405b7c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/fsouza/fake-gcs-server.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    pid = spawn bin/"fake-gcs-server", "-host", "127.0.0.1", "-port", port.to_s,
                    "-backend", "memory", "-log-level", "warn"
    sleep 2

    begin
      output = shell_output("curl -k -s 'https://127.0.0.1:#{port}/storage/v1/b?project=test'")
      assert_equal "{\"kind\":\"storage#buckets\"}", output.strip

      # Create a bucket
      shell_output("curl -k -s -X POST 'https://127.0.0.1:#{port}/storage/v1/b?project=test' " \
                   "-H 'Content-Type: application/json' -d '{\"name\": \"test-bucket\"}'")

      # Verify bucket exists
      output = shell_output("curl -k -s 'https://127.0.0.1:#{port}/storage/v1/b?project=test'")
      assert_equal "test-bucket", JSON.parse(output)["items"][0]["id"]
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end