class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.28.1.tar.gz"
  sha256 "27a162a62f547b786b12d16813948473c67da201df4d367982f4d7fc4bda6f4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa8308cf24cadfb6c185a18cfe318e2ca03fc7f46960606ef90a7d62c2fbaf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa8308cf24cadfb6c185a18cfe318e2ca03fc7f46960606ef90a7d62c2fbaf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fa8308cf24cadfb6c185a18cfe318e2ca03fc7f46960606ef90a7d62c2fbaf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "57ef31113ba7513a9ba22737c579e4dbd0d390a5e858172950c0f6ba3117f67f"
    sha256 cellar: :any_skip_relocation, ventura:       "57ef31113ba7513a9ba22737c579e4dbd0d390a5e858172950c0f6ba3117f67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e741fbb3e07adeb307aa6a0912575091166b8fd4957249872bc8108fcd1634c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed0509aede1a79739508551e7871b0ca839e6d2f82f23c40c981d5d45e32d40"
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