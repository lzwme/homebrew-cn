class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.27.tar.gz"
  sha256 "08a3ec4cacf2094b986cf9734bba12461a673bacdbb51ccc2ba349db2e1baac3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb916075a179e91eacee9d4e83e3fa86494fe99de9c2b7c96d045180dc979224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb916075a179e91eacee9d4e83e3fa86494fe99de9c2b7c96d045180dc979224"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb916075a179e91eacee9d4e83e3fa86494fe99de9c2b7c96d045180dc979224"
    sha256 cellar: :any_skip_relocation, sonoma:        "34be7f6fb11e1e2757fe89549db27fc8e405fd2fe9ba4b238037a196eef3479a"
    sha256 cellar: :any_skip_relocation, ventura:       "34be7f6fb11e1e2757fe89549db27fc8e405fd2fe9ba4b238037a196eef3479a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25b8555dcac0c58cdcbc5d464920b14932b5badd1de20ccea62192c5988e4e86"
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