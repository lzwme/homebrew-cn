class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.26.0.tar.gz"
  sha256 "5bf36b5a1abae5f4670b651a610d7a273417a66b944bb095e1e6f782eae02695"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68dac77e72976cc409682d674cf20bcaee56f679bf2f84d4ea19c02d97301347"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68dac77e72976cc409682d674cf20bcaee56f679bf2f84d4ea19c02d97301347"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68dac77e72976cc409682d674cf20bcaee56f679bf2f84d4ea19c02d97301347"
    sha256 cellar: :any_skip_relocation, sonoma:        "1419967957de582883bd01a7a50a38693918a8941ce9f45a4a97518d4839eb0c"
    sha256 cellar: :any_skip_relocation, ventura:       "1419967957de582883bd01a7a50a38693918a8941ce9f45a4a97518d4839eb0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04fdf454e682c6c7be8c071edce1579003a5922b498d73173eaffd63549787ff"
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