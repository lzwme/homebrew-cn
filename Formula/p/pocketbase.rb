class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.25.8.tar.gz"
  sha256 "54cbe297798c6875788a87fe9ff38b5d176e76a054f2bcc87a8e51f9fedd9652"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2340c6ff393eaec52ca7ac4b800811631e4986b5aae8b035d491133c19ca840e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2340c6ff393eaec52ca7ac4b800811631e4986b5aae8b035d491133c19ca840e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2340c6ff393eaec52ca7ac4b800811631e4986b5aae8b035d491133c19ca840e"
    sha256 cellar: :any_skip_relocation, sonoma:        "792b1c26d2d3d28b8a77fc61f063c03124f19e979b7f5cc0179bffbb88796793"
    sha256 cellar: :any_skip_relocation, ventura:       "792b1c26d2d3d28b8a77fc61f063c03124f19e979b7f5cc0179bffbb88796793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "818f5cf3a43a6b27718c41bb688b37604a898253331f2928425bce01df2b5ddf"
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