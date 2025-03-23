class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.26.2.tar.gz"
  sha256 "04896ebdab79b3e5a8e2f629dd6334aaa2d8e0c894625b8da7b8600223d3672f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae46c5921908fe1d95c9bd5417a6f78b7786f1ad55ba61f7edf2a61acdcaaeb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae46c5921908fe1d95c9bd5417a6f78b7786f1ad55ba61f7edf2a61acdcaaeb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae46c5921908fe1d95c9bd5417a6f78b7786f1ad55ba61f7edf2a61acdcaaeb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "69e04fedf730fd9b4038fd0efe331ad80f92cab22565f784ff850c98056a9d5a"
    sha256 cellar: :any_skip_relocation, ventura:       "69e04fedf730fd9b4038fd0efe331ad80f92cab22565f784ff850c98056a9d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd8fc56198940fe07258d82ae9e29f45bcf282c155ebaf6135bb0628411ccb7"
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