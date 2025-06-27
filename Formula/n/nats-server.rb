class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.11.5.tar.gz"
  sha256 "a143d88ace5dc4c2085650d98c4c7f59e6739f3865e3c81a8ee98bd4a2106cae"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee21beb393bf2f2549441322cd853914a6e9cadcd4b2f864fdb63114bfae201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ee21beb393bf2f2549441322cd853914a6e9cadcd4b2f864fdb63114bfae201"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ee21beb393bf2f2549441322cd853914a6e9cadcd4b2f864fdb63114bfae201"
    sha256 cellar: :any_skip_relocation, sonoma:        "749cdafe60e5bab1ba4e8c58723f55568c39bf4e1e8389d316d79b4dbc2b472d"
    sha256 cellar: :any_skip_relocation, ventura:       "749cdafe60e5bab1ba4e8c58723f55568c39bf4e1e8389d316d79b4dbc2b472d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6897777b8ba244e4aba682f6d245884c9e8ab682090454ca07c259c1e721276e"
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
    assert_path_exists testpath"log"
  end
end