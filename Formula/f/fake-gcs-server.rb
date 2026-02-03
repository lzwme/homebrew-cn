class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://ghfast.top/https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "a8ebab36ebd9c4795cb13759909b57e5c20a29b8d071ea15006f6588ccca6a32"
  license "BSD-2-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbaa7844e2b0ff0a395804c2c2795a6bee87116058e2255fbe9ab0e54b779bc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbaa7844e2b0ff0a395804c2c2795a6bee87116058e2255fbe9ab0e54b779bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbaa7844e2b0ff0a395804c2c2795a6bee87116058e2255fbe9ab0e54b779bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "110df54768b84ac6957b45f833bffb4629a1b06bc59316e1048660bcc81ac8b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34ecf4c915facbf09d0302cc71af587b836969f2d9ecd394bfbadb3890caaf96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b171c6ec325110fbeac260a34e3ed8cfbcfbd0427bd4e245f5c77a23142c1d"
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