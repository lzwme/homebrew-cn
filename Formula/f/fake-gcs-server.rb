class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://ghfast.top/https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "e8fbf21a0d57e350dc389d2639b80beef53bf50b15b59e10cdaa24af9f7425db"
  license "BSD-2-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9729ee3e1ca4d2eb90231120485e26c48f9ff2cdefa54cd8d154034ea93907ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9729ee3e1ca4d2eb90231120485e26c48f9ff2cdefa54cd8d154034ea93907ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9729ee3e1ca4d2eb90231120485e26c48f9ff2cdefa54cd8d154034ea93907ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "bebf2b47f17ca25526f808a076e7b758754ed3b9356b18f2812b649e592ddcfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd18755a954718cb0e23482219c2881fe8bdb71e742af4d5da58360d45af66c0"
    sha256 cellar: :any,                 x86_64_linux:  "0f18b073cf76c36ae994c869eabed84d1fe30c7b3214578e74da233ba7d83e7c"
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