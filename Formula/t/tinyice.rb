class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://ghfast.top/https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "2216adbfd529a2d0a80b2aa98753ef73fd7405f1706e5162a7540831e2705e39"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "194d28756ef3d0631c076fe8624eb0a88d416b02b24088b0567350175d88d201"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "194d28756ef3d0631c076fe8624eb0a88d416b02b24088b0567350175d88d201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "194d28756ef3d0631c076fe8624eb0a88d416b02b24088b0567350175d88d201"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad0fd1a0c847bbac8dd562d72de17c52c43ee4bbe13287fb0cd142528d8183c4"
    sha256 cellar: :any,                 x86_64_linux:      "31c10698052efcba01c6f3babe252952d2a3bf62f0dcb425b98f156fbf312a13"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"tinyice"]
    keep_alive true
    working_dir var/"tinyice"
    log_path var/"log/tinyice.log"
    error_log_path var/"log/tinyice.log"
  end

  test do
    port = free_port

    # Write minimal config
    (testpath/"tinyice.json").write <<~JSON
      {
        "bind_host": "127.0.0.1",
        "port": "#{port}",
        "admin_user": "admin",
        "admin_password": "test"
      }
    JSON

    pid = spawn bin/"tinyice", chdir: testpath
    sleep 3

    begin
      output = shell_output("curl -s --fail http://127.0.0.1:#{port}/")
      assert_match("TinyIce", output)
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end