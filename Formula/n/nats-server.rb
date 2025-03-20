class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.11.0.tar.gz"
  sha256 "26c220c06ebbaef5f3a4e555bb1e6071286c94508da4c2215b66b0d5c0b75b30"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a26ecb4565f82805c8e274dfa033d90c2fe6778e541780d6371beef63d9251c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a26ecb4565f82805c8e274dfa033d90c2fe6778e541780d6371beef63d9251c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a26ecb4565f82805c8e274dfa033d90c2fe6778e541780d6371beef63d9251c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceccded17990ee3b894a1c05bfa1d3dde6b446686d0a1b05bee463e02ee7dc91"
    sha256 cellar: :any_skip_relocation, ventura:       "ceccded17990ee3b894a1c05bfa1d3dde6b446686d0a1b05bee463e02ee7dc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ea40c11d56e27e19a17e0e1715acc6ac9b8be46b7f43b7de3b9d511d2fec68"
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