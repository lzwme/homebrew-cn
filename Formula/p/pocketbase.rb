class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.28.0.tar.gz"
  sha256 "3d17eb510f3d700a10b02fc4a6bacbe063b06e9241f30b036fec346b8d2e2923"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dd2a8a13e2299964fd85ef8f7a46d636032517c49c582cfa8dd42a9d2f2b8b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd2a8a13e2299964fd85ef8f7a46d636032517c49c582cfa8dd42a9d2f2b8b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dd2a8a13e2299964fd85ef8f7a46d636032517c49c582cfa8dd42a9d2f2b8b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "92bcf76893094c36c4cc7242bacbf749aa6aa882f0fe372e73df53e4ab00a5bc"
    sha256 cellar: :any_skip_relocation, ventura:       "92bcf76893094c36c4cc7242bacbf749aa6aa882f0fe372e73df53e4ab00a5bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4112eefb4b85aba9ca152d656aa1771e69dd8fe68a3af9930349711b35db7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94499c36a9e54394f52ce5640c986edcbbb100c869a9c1b55c8fc3ad71e835c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.compocketbasepocketbase.Version=#{version}"), ".examplesbase"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}pocketbase serve --dir #{testpath}pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http:localhost:#{port}apihealth")

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
end