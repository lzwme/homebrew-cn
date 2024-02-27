class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.0.tar.gz"
  sha256 "ded823bd6b205ec3abe0fdef1ef97b37a7a9d6f83d84d37a88cc7276a34b8fcb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c5a806c67443a3ad003de9bd75e71dceab25062d30be000b89b88cde18d5487"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c5a806c67443a3ad003de9bd75e71dceab25062d30be000b89b88cde18d5487"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5a806c67443a3ad003de9bd75e71dceab25062d30be000b89b88cde18d5487"
    sha256 cellar: :any_skip_relocation, sonoma:         "35cfbc4c70a08f10eeb76fd6374fbbb172e9cba0b001c67aeb05634bebb4b15f"
    sha256 cellar: :any_skip_relocation, ventura:        "35cfbc4c70a08f10eeb76fd6374fbbb172e9cba0b001c67aeb05634bebb4b15f"
    sha256 cellar: :any_skip_relocation, monterey:       "35cfbc4c70a08f10eeb76fd6374fbbb172e9cba0b001c67aeb05634bebb4b15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f80edb2f085a04081765964b1a061c0e1ddbcc7515d0bbe293055eeb29596c"
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