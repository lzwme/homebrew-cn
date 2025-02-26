class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.26.tar.gz"
  sha256 "93b148667baf06f58c00f104e0fe016dbab195e4acac868d8b45117646337409"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775c3573ff718aa58617f771b06503b26219eb4eed373c7d866590d19dea998e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775c3573ff718aa58617f771b06503b26219eb4eed373c7d866590d19dea998e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "775c3573ff718aa58617f771b06503b26219eb4eed373c7d866590d19dea998e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aae16ad3b89a4ef759055c99f9debcc2ef2989d5e535c2a6ea82fa0824282e8"
    sha256 cellar: :any_skip_relocation, ventura:       "8aae16ad3b89a4ef759055c99f9debcc2ef2989d5e535c2a6ea82fa0824282e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b332aa0dc791d48f93a79d0d02ca821801a3463d1b6178053ba9bbe80518368c"
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