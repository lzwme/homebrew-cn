class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.12.tar.gz"
  sha256 "4462f0f4e21d244f079ba31df9a384e22ad4b7616c8af475b46140268030a985"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99b173d833c7b28942215babd1891bd449259fa4464f77366289cc46cfa5cbed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b173d833c7b28942215babd1891bd449259fa4464f77366289cc46cfa5cbed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99b173d833c7b28942215babd1891bd449259fa4464f77366289cc46cfa5cbed"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c11de7e326f6dc3ba9d70fe851fce39b69ab748b6c2acac05867b67307f7316"
    sha256 cellar: :any_skip_relocation, ventura:       "6c11de7e326f6dc3ba9d70fe851fce39b69ab748b6c2acac05867b67307f7316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c073d81031bdc8840efb131c01d56c05a75afade1610ffad806389bd21f193c6"
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