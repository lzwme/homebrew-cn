class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.19.tar.gz"
  sha256 "3098a9fe78fcaa5d8af4d8c0eb51263cded117f9b54f736085a36d0292323bbf"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44150fe95fdaef76ccffa3ea5975f27e1f3f9c74b34ec72d36ddd1babce5146d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44150fe95fdaef76ccffa3ea5975f27e1f3f9c74b34ec72d36ddd1babce5146d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44150fe95fdaef76ccffa3ea5975f27e1f3f9c74b34ec72d36ddd1babce5146d"
    sha256 cellar: :any_skip_relocation, sonoma:         "118b2f85d5333a8247a4a5f3114aba52a8dc628013570449df1e37f21cf9a1a8"
    sha256 cellar: :any_skip_relocation, ventura:        "118b2f85d5333a8247a4a5f3114aba52a8dc628013570449df1e37f21cf9a1a8"
    sha256 cellar: :any_skip_relocation, monterey:       "118b2f85d5333a8247a4a5f3114aba52a8dc628013570449df1e37f21cf9a1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "570469eae5fb5bd41ab18b93d564c893babe8309685d694260ef0f4b7cefeade"
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