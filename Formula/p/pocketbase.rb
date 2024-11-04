class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.23.tar.gz"
  sha256 "f7780c2579450ba94e81b02f105b39cca87087f134753f0dbdae851e3848506f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b6de8b3fcd8748da2e9b7aa9a5aefa02a7a0ef743886917f3a2f87349402c87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b6de8b3fcd8748da2e9b7aa9a5aefa02a7a0ef743886917f3a2f87349402c87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b6de8b3fcd8748da2e9b7aa9a5aefa02a7a0ef743886917f3a2f87349402c87"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f93428658967a98b0fe6bf6c7e15f3a3efd7d357e84fe64ed8748f166e661fa"
    sha256 cellar: :any_skip_relocation, ventura:       "1f93428658967a98b0fe6bf6c7e15f3a3efd7d357e84fe64ed8748f166e661fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6bf8750c2c99a086a1c1dfaff08c8c6d7872a9004c652c0ec08ad476b23ce28"
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