class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.24.0.tar.gz"
  sha256 "29dac45deb38b1ba6c1c3ddc439092c3b5b98a3ffdf97c6802037b01a8ce19c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c187c149912dd236d91909ccd85a8c0ece6c486ae513f26f7b9c2651f36a85c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c187c149912dd236d91909ccd85a8c0ece6c486ae513f26f7b9c2651f36a85c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c187c149912dd236d91909ccd85a8c0ece6c486ae513f26f7b9c2651f36a85c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "24620ff4951ba57534dcea5d1cc1ed05a3f5052f777b5464579b3ba0839b8347"
    sha256 cellar: :any_skip_relocation, ventura:       "24620ff4951ba57534dcea5d1cc1ed05a3f5052f777b5464579b3ba0839b8347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71dc07ddf41d4bdab49dbb0efba58b388704c051063f5ff2830bd0da789a4cde"
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

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_dataauxiliary.db", :exist?, "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end