class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.20.4.tar.gz"
  sha256 "d7d973c960520289f10142edf6d64dc1bbb1fc207723129f31bfb949ba20f4d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "960ac25c66a46a305d0c7aa499b6620d60999f965d7ad73de3d5f9395f728450"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "960ac25c66a46a305d0c7aa499b6620d60999f965d7ad73de3d5f9395f728450"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960ac25c66a46a305d0c7aa499b6620d60999f965d7ad73de3d5f9395f728450"
    sha256 cellar: :any_skip_relocation, sonoma:         "16731d1666152150c26d6facd4b80bfadbe62ab6e57ff951eeb1d62c45f012a5"
    sha256 cellar: :any_skip_relocation, ventura:        "16731d1666152150c26d6facd4b80bfadbe62ab6e57ff951eeb1d62c45f012a5"
    sha256 cellar: :any_skip_relocation, monterey:       "16731d1666152150c26d6facd4b80bfadbe62ab6e57ff951eeb1d62c45f012a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d94239a9bc995e6720b951c7c47d8701e84216d76d1804ebd452b6396dce0c"
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