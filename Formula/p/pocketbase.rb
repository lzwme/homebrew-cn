class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.16.tar.gz"
  sha256 "7442b712ee9f858eed4577d45a582bd5a32a0e1efbcf9ca84ccfaf2c36bccdbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7f8d0ca5cab23c96d374dba057905f3112ceb94e65ef67b04ce3326a10dd731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7f8d0ca5cab23c96d374dba057905f3112ceb94e65ef67b04ce3326a10dd731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7f8d0ca5cab23c96d374dba057905f3112ceb94e65ef67b04ce3326a10dd731"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e657b91e0f6f567bbe37cd1f145207c47ded44ef037f2b1b4673b340dabd94b"
    sha256 cellar: :any_skip_relocation, ventura:        "3e657b91e0f6f567bbe37cd1f145207c47ded44ef037f2b1b4673b340dabd94b"
    sha256 cellar: :any_skip_relocation, monterey:       "3e657b91e0f6f567bbe37cd1f145207c47ded44ef037f2b1b4673b340dabd94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecba0dce1fec0c5a4f06fcad7010d6d52b63e5212a1d999540f8af15bd99e28d"
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