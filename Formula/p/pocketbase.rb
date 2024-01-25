class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.21.1.tar.gz"
  sha256 "2a1dc9a88438a7af263ee5acd0b837645eb127a995a20072ba3efde51cc12b07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a7efc5c5fbe00e6f318da315728e295af9535f258b51863b60a4d321d9a55f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a7efc5c5fbe00e6f318da315728e295af9535f258b51863b60a4d321d9a55f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a7efc5c5fbe00e6f318da315728e295af9535f258b51863b60a4d321d9a55f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "494e5be533bf553cecee58665bae5ec1bf25cde95e7ba8649c4dd3836d0c22f4"
    sha256 cellar: :any_skip_relocation, ventura:        "494e5be533bf553cecee58665bae5ec1bf25cde95e7ba8649c4dd3836d0c22f4"
    sha256 cellar: :any_skip_relocation, monterey:       "494e5be533bf553cecee58665bae5ec1bf25cde95e7ba8649c4dd3836d0c22f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5d78ce24247c188cc5f82492e790739e3768f8e1706afdb62a5224fb28b8c3"
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