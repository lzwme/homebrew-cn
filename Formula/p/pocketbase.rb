class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.28.3.tar.gz"
  sha256 "6f0fe18279f9b98047d8379562e1e2d16a652babd431f72f806e8af8b7dfd47a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01819e0ba49db47de67e851d6684c7b2c3109eb2f7517e21f7f102f956353aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01819e0ba49db47de67e851d6684c7b2c3109eb2f7517e21f7f102f956353aca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01819e0ba49db47de67e851d6684c7b2c3109eb2f7517e21f7f102f956353aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "dccb126efe889e9bf85cd5ab3de3194ff8c686b398f25ea89c3c8a00f0a2e8bb"
    sha256 cellar: :any_skip_relocation, ventura:       "dccb126efe889e9bf85cd5ab3de3194ff8c686b398f25ea89c3c8a00f0a2e8bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e736bfdf1f3a7f0a6b21495d923160f24cfcf1c8a21b36b939713d622d92d9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b68f5b3f351bafb6fc89a429d2ff1f94471e17ea837b0f97cbdfbb02048467"
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