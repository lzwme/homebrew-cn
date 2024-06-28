class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.17.tar.gz"
  sha256 "66d2c5b8ddfd4cb7b83c58a8df82e884b9193531cec00c8952f847b6eb848506"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "814dad34bf8ebefc8d263f99dffa071cdc6430861b8f895f9bef72aeb0b90de7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06fad61fc587f637aaaf64382ede3908e0931f01c397dd5d16dc96af7babdb3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d3d6e84d943f29fd33e813feb58a93545647e5bfed8979741e8284150c454fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e4875e49d7a39598302cd2d757ca715d4a1eadfa67fd7c6138b00cb8caab66e"
    sha256 cellar: :any_skip_relocation, ventura:        "a377e46002e707ed040178b7db9f89da255639ea4f517c9d327a2c1f2f425314"
    sha256 cellar: :any_skip_relocation, monterey:       "537c78f89a3f5329b39275e12df7bba94078880d34b56a07a52314e24b3561c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd38b7e793efb763212b3bd896ad7e67f61f70635965e351e3cc4465eaaf943"
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