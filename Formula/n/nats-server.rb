class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.23.tar.gz"
  sha256 "60b9bbdb84661e9fe1c3834ab1fb421ed74453dd35dc206c04d3272f85b93f28"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a98792cf3adfcc684afde47c42cbb962d6d8568dcc15c9539b93f9932ca83e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a98792cf3adfcc684afde47c42cbb962d6d8568dcc15c9539b93f9932ca83e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a98792cf3adfcc684afde47c42cbb962d6d8568dcc15c9539b93f9932ca83e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fac64ffcd17a860fc58b071ae5b94b927d254c00f9176bf94de34009ffdf1acf"
    sha256 cellar: :any_skip_relocation, ventura:       "fac64ffcd17a860fc58b071ae5b94b927d254c00f9176bf94de34009ffdf1acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f083e449f561f1486da3516684a037c2307c0ac331b26a61487a5d481dcc20d"
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