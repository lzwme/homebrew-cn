class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.25.tar.gz"
  sha256 "01c9eebd92beac80077f07cb93e2f83417276e71384326e786a212bc5c3f3e51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8dfa2fbcdd0cdd3c161f7bb0bff1a09daa3d7079bdf12a70a8ae35060064898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8dfa2fbcdd0cdd3c161f7bb0bff1a09daa3d7079bdf12a70a8ae35060064898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8dfa2fbcdd0cdd3c161f7bb0bff1a09daa3d7079bdf12a70a8ae35060064898"
    sha256 cellar: :any_skip_relocation, sonoma:        "838042d843aef98ead9843b78d60e25995a11b893b9678a9665484312344b289"
    sha256 cellar: :any_skip_relocation, ventura:       "838042d843aef98ead9843b78d60e25995a11b893b9678a9665484312344b289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c46f884e369a42859ee4ffc21e22ad2e91551619b05e58f6fd9d0da82476e14"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.compocketbasepocketbase.Version=#{version}"), ".examplesbase"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}pocketbase serve --dir #{testpath}pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_datalogs.db", :exist?, "pb_datalogs.db should exist"
    assert_predicate testpath"pb_datalogs.db", :file?, "pb_datalogs.db should be a file"
  end
end