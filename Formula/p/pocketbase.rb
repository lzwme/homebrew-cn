class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.7.tar.gz"
  sha256 "cecaaf84884de0f24042171ef50060d0dbf5b6d14b9080b51963aed1200bdfe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cde2100306f23da309e73e6472837e6b1cd02072afc3c6b91391d9789fc527ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde2100306f23da309e73e6472837e6b1cd02072afc3c6b91391d9789fc527ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cde2100306f23da309e73e6472837e6b1cd02072afc3c6b91391d9789fc527ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "039c70461f066f4d0c7258ffd0888afc10101f8aec66f87f7aacbb9f22b5347c"
    sha256 cellar: :any_skip_relocation, ventura:       "039c70461f066f4d0c7258ffd0888afc10101f8aec66f87f7aacbb9f22b5347c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8edd472453a0952a11d9ad0264f15d002a5ef1521726e80756a3d4d796844c1d"
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

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_dataauxiliary.db", :exist?, "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end