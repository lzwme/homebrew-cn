class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.24.tar.gz"
  sha256 "9f8f3cc56525babee6fbfc6a9b1af15e738481dab9f3bf51cb5511d5d718e57c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "982800d4d33d0977429ca54404e579297f5bc779cc7bb1b1c1fc3936c18f8a94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "982800d4d33d0977429ca54404e579297f5bc779cc7bb1b1c1fc3936c18f8a94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "982800d4d33d0977429ca54404e579297f5bc779cc7bb1b1c1fc3936c18f8a94"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d3faf780bee9039ba3f4a73a1e3afb225ceeb428e0ff26a2f1245f0c7cad20c"
    sha256 cellar: :any_skip_relocation, ventura:       "6d3faf780bee9039ba3f4a73a1e3afb225ceeb428e0ff26a2f1245f0c7cad20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88da40f34262fa574ae7ecef84a0c8b7b367867f490d5f1dfb58c44f29e31662"
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