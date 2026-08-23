class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://ghfast.top/https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "cd4281c8164743a71bbcf83f6f9b8a0059bde175c65ac95cfc24d7dc5e8e7ef1"
  license "BSD-2-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c85b61e50841b899d4addc3f46a352e03a006caae26959e1c1aa7386a7f0ab6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c85b61e50841b899d4addc3f46a352e03a006caae26959e1c1aa7386a7f0ab6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c85b61e50841b899d4addc3f46a352e03a006caae26959e1c1aa7386a7f0ab6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9269624af06038935cb0686861dfac50cd1810fde6d0aec9dd8067aacc13e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4f664aa1ee34f633ca549ab04276ec79e73feb92edd0fb9c60994733af85b27"
    sha256 cellar: :any,                 x86_64_linux:  "e85461f0cfbae8e4e4f7046be72328d4f210b6540f5658a3679595817aff3e7e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/fsouza/fake-gcs-server.Version=#{version}"
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