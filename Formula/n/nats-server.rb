class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.10.tar.gz"
  sha256 "c1228e9a0d2ea8390c3b7d17cffc24f76dfa182197bb447e947c1ef6e0b005b4"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3b9701f05920825a0162f7fa978a66c0ea07f42b152fdce2f6168cec3e9b06d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b45aca6c2b1347f77133d3e156988219886519eeeb114b5b4e55116fc6653c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6bb12f373ba7f21b29443c13e99cec3cbf04f2d771e61ca1870578b17b27b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dd6714c6e873badbc25932e2c968a6fb6cadcd0586c688b26c0a3af80855f01"
    sha256 cellar: :any_skip_relocation, ventura:        "8434ac3659f45d028f45e0fdc1092fa5a779e4bb76539c530ebcd2193b72e810"
    sha256 cellar: :any_skip_relocation, monterey:       "e76092bf99aaf30692bf0cd1f779ada0a693f7122527717a7ee980c8798ff762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e1a1368bc2e4ff53df8f21a99220989df647ddad1962945d0e7f3400546dda"
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