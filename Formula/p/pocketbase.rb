class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.12.tar.gz"
  sha256 "cca20f3c6899aa0a7203e6cab7b0ce0eb87c1772454f49766ac1b445fb86da01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b065f2bfb17501f399a284ae81018df38f423ae5d0455c0947af8493b88670d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8145148ed746591e66ed2e7573b1691520a60031950cd357c12ae6eb7a694c3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "798dbfe7ce583b3efda4f15d4db255bc33fc02d2a888cc11cedcb96c36ebdca8"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcf15d49c94548d9b7e2bab8144c804babcc0492ce219f78b1320adb4764548c"
    sha256 cellar: :any_skip_relocation, ventura:        "3e0e7857e58476fa302493977fec976006a90279f84018778426aca72a68dc46"
    sha256 cellar: :any_skip_relocation, monterey:       "302ded6936e7e892485cde4ba10d03f8a266eea2e985bf2cd9e061120998c983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc4ee6c7779cdfa877e26557cf8d1058b3cb01f4be1d6c270689bb06a9ae800c"
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