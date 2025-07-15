class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://ghfast.top/https://github.com/welovemedia/ffmate/archive/refs/tags/1.1.0.tar.gz"
  sha256 "76ee7cf34bb12fbf6af162013dda8ca894c179b2525a18ece563b409b74ef1cc"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8affa0bf4d637bcadd380d174bf1f498685d8c4e6113756da94f48a9aef7ae1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a61aa543f3b12f528a921ba873c461915dc3f85a89a4c9cd6cbfc3020cad50a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ea8b2043b83984d664ef6f9e7e2633e104bb07ff18aeaff29bdde3c82ae53d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6711f573881e148e8cadfdd8f37326819a07d81bcea6f4b0c1250f2e2fab1380"
    sha256 cellar: :any_skip_relocation, ventura:       "8febe1353812b42be4a58edbd2f9f7c1d1e5beea4bd5f0a00916b2d57eeb7973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1f32393f8298b99df4fd76d73f859661bdabdf700bcb2fdf72349f1526a1498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc44b707cc10b5e73faccb5a62f655091fea5a994eaa8bb5f45f6b9fcd62f976"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "json"

    port = free_port
    args = %W[
      server
      -p #{port}
    ]
    preset = JSON.generate({
      name:        "Test Preset",
      command:     "blah",
      description: "fake it",
      outputFile:  "test.mp4",
    })
    api = "http://localhost:#{port}/api/v1"
    pid = spawn(bin/"ffmate", *args)
    begin
      sleep 2
      assert_match version.to_s, shell_output("curl -s #{api}/version")
      assert_match "uuid", shell_output("curl -s -X POST #{api}/presets -d '#{preset}'")
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
    ensure
      Process.kill "TERM", pid
    end
  end
end