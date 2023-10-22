class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://ghproxy.com/https://github.com/dtm-labs/dtm/archive/refs/tags/v1.17.8.tar.gz"
  sha256 "8dfb94582bf07c58ad39c4a0707f51e0269c2ad86c74c1eca4061574ab731eb0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d96a6950fd9ce82a53d35f846f04d8143e1d9a6c1c347ea4361fe7c92e545b97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "090fbf169bdbf175c2483a8960bc6832e43f069853f2fa24c8cf584afd0e0b92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd664f1ac053f7d73351adccf162a215fbe6511a7d0768b0d5d8df601953e4cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "0991230e0d62d106edbfa259d5bb56de451d03516254062234baea7f55177d44"
    sha256 cellar: :any_skip_relocation, ventura:        "1d5a63129262b2859798ab243238c18bc18cbc0ea4f6dc34dc7fe0411df65fdc"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3e5e6932a44c5d8e875f25f232ec6ffc31b12caa00d2331705ea3f05f40a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2c88d4b6d9dc3ccc1023cd78434e1a0c80d60d49d7270afcc38d981afb5af6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")

    http_port = free_port
    grpc_port = free_port

    dtm_pid = fork do
      ENV["HTTP_PORT"] = http_port.to_s
      ENV["GRPC_PORT"] = grpc_port.to_s
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    metrics_output = shell_output("curl -s localhost:#{http_port}/api/metrics")
    assert_match "# HELP dtm_server_info The information of this dtm server.", metrics_output

    all_json = JSON.parse(shell_output("curl -s localhost:#{http_port}/api/dtmsvr/all"))
    assert_equal 0, all_json["next_position"].length
    assert all_json["next_position"].instance_of? String
    assert_equal 0, all_json["transactions"].length
    assert all_json["transactions"].instance_of? Array
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end