class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://ghfast.top/https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "cc303f853911962325f14bd09dbdbfb1edcffe76f890bfb150b13517ab15f1d4"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a865df3094aec7fc8e6f839ae6cc448a027ecb55e1e96e1ad8508f256651b47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a865df3094aec7fc8e6f839ae6cc448a027ecb55e1e96e1ad8508f256651b47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a865df3094aec7fc8e6f839ae6cc448a027ecb55e1e96e1ad8508f256651b47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57d791396504f540f0af008a5df45df53f33048ef5cd46aa6866dece9b7c1003"
    sha256 cellar: :any,                 x86_64_linux:      "3204ea4a9fdd435ba424c9df7710eaf3ad503cc456ed9fb6b3c2de252d4bf9e5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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