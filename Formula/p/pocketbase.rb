class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.7.tar.gz"
  sha256 "35423b68c69c3f905b66275684e66bb5ec63c020a248270078a4100a917b309a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb4e7a0a66294ace3eab1e632c7fd1ccf55998ac76e23a2b6cebdbb6da4ee48d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb4e7a0a66294ace3eab1e632c7fd1ccf55998ac76e23a2b6cebdbb6da4ee48d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb4e7a0a66294ace3eab1e632c7fd1ccf55998ac76e23a2b6cebdbb6da4ee48d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ad5b75af15b2348cfb8bc0ea186af2c767c51dd346c2cb998f9affc10eef810"
    sha256 cellar: :any_skip_relocation, ventura:        "7ad5b75af15b2348cfb8bc0ea186af2c767c51dd346c2cb998f9affc10eef810"
    sha256 cellar: :any_skip_relocation, monterey:       "7ad5b75af15b2348cfb8bc0ea186af2c767c51dd346c2cb998f9affc10eef810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71618d839d52f81a09c73c3a15f51421bb30128190872ea868416259cbee7256"
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