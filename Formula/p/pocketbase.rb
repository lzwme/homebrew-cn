class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.9.tar.gz"
  sha256 "c46f55ecf45ac3acebbc7eaeedd7abc8f3f56ce64dc1930a83caf4aa68a8922e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c52426c724bd384b3c8171a757d317160a76990f0f5b324b2a0133271c4aa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c52426c724bd384b3c8171a757d317160a76990f0f5b324b2a0133271c4aa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7c52426c724bd384b3c8171a757d317160a76990f0f5b324b2a0133271c4aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bdaddc2a994e09bf2542aa7e34b5741c3be6d49fbda76be83ade0bd390a83b3"
    sha256 cellar: :any_skip_relocation, ventura:       "5bdaddc2a994e09bf2542aa7e34b5741c3be6d49fbda76be83ade0bd390a83b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358f89b2639da0208166b53b78c6cfc57c1aa4f97b7c52a7b7c3026416d1ff0e"
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