class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.25.7.tar.gz"
  sha256 "987e8442c615e0f755f49925906fbc1031922c6e549dcf621d8c53373ff201b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d03f867ad0feb0244da0414426bd6cdedde9a7bc9512cd48fd9eed5bf5dba476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d03f867ad0feb0244da0414426bd6cdedde9a7bc9512cd48fd9eed5bf5dba476"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d03f867ad0feb0244da0414426bd6cdedde9a7bc9512cd48fd9eed5bf5dba476"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1011e5dd8fc3dd1964179f56347c6c0d8498c0e094d6d9a8af8e5091552f70e"
    sha256 cellar: :any_skip_relocation, ventura:       "a1011e5dd8fc3dd1964179f56347c6c0d8498c0e094d6d9a8af8e5091552f70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba87dd4993f9ff7cb64f611c0d1157c9f3d7f0531ffb4ad4e98e3101792c931"
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

    assert_path_exists testpath"pb_data", "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_path_exists testpath"pb_datadata.db", "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_path_exists testpath"pb_dataauxiliary.db", "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end