class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.15.tar.gz"
  sha256 "759b96acc95c6c3d8f96414ee0bbb2b24a3f38342eb7e2cc35f16adb83dcfc14"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4635dad3f2005c38513f4d4cc4affd484f5da7dff6e121f9a5bc6f6f968bdcdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f668a633fdca712ba3a2f57f41e886b2a177f597541a8001d113563580016b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ee8382befb388131d8af12dbc770f46e35ad06b7f109104435859a521300a56"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e1cf1262a57f5274ff1ce8fb0d5d78927167da171a07e2b348ec902896ef751"
    sha256 cellar: :any_skip_relocation, ventura:        "1de35a39a2774043a7faf841ce2873f069473a20c8d06168c612532922ec79be"
    sha256 cellar: :any_skip_relocation, monterey:       "9a64b75c99d1c6626d901c2c7febeebb8a230dabf26952b3197aa4361a150e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e7b6237ef3c3aef2c3a14233fcf5d988a9bc8b52567d6140e41ce88ccbe00f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}pid",
           "--log=#{testpath}log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}varz")
    assert_predicate testpath"log", :exist?
  end
end