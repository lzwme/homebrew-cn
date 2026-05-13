class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://github.com/DatanoiseTV/tinyice"
  url "https://ghfast.top/https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "f54d5957f67d4229648b59b0e9c4c40d07f53fac7fbeb0245a1f2654322bdc4c"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf4fe9d8899d1316ca34679a13365bdaed980d1f6aae4cddcca9f00c8ee28b4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4fe9d8899d1316ca34679a13365bdaed980d1f6aae4cddcca9f00c8ee28b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf4fe9d8899d1316ca34679a13365bdaed980d1f6aae4cddcca9f00c8ee28b4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e4dd449cd1c810a2ecb3ee5115f5c721187ffe9f813f3346f186ba1a82ccf75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18b30064b7ad46234bcc540b828c8e81c01952b033a11bdd225aab725c0d499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91bf58d32c1f744ebf1959dd0d76a41ac8097de3755cb14645a6b850f5d9fad9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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