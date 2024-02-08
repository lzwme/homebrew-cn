class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.21.2.tar.gz"
  sha256 "0db8409bf4fd220f2a3da7c44fa69908acc8919ad420b4aac71dbc7298538460"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5758551074cf6865d38f3b76f07c51bd47fb6c8b0b525760bbd80a64064da52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5758551074cf6865d38f3b76f07c51bd47fb6c8b0b525760bbd80a64064da52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5758551074cf6865d38f3b76f07c51bd47fb6c8b0b525760bbd80a64064da52"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc797e3d4a658cfa1a6c215d5931d0df8c4b2d344860b20cf3df2c39d7facfe0"
    sha256 cellar: :any_skip_relocation, ventura:        "bc797e3d4a658cfa1a6c215d5931d0df8c4b2d344860b20cf3df2c39d7facfe0"
    sha256 cellar: :any_skip_relocation, monterey:       "bc797e3d4a658cfa1a6c215d5931d0df8c4b2d344860b20cf3df2c39d7facfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95762d63730cd69cc4d044c252dd31bafcf79f1645748ba9ac081c6b95d3b500"
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