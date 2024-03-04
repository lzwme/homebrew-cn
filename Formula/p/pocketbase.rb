class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.2.tar.gz"
  sha256 "1759252ac9930756901434260656f3f4e7a0ee104dd8e4ba6e63b97865ef380f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4db0cc771bac4af56bbbb3b80c0807d499dd9407569d183fee4ea17c694e7d21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db0cc771bac4af56bbbb3b80c0807d499dd9407569d183fee4ea17c694e7d21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4db0cc771bac4af56bbbb3b80c0807d499dd9407569d183fee4ea17c694e7d21"
    sha256 cellar: :any_skip_relocation, sonoma:         "de7a3afba859c9cbaf79c0c26ad996c79b455429e815f540f88be10c92f68248"
    sha256 cellar: :any_skip_relocation, ventura:        "de7a3afba859c9cbaf79c0c26ad996c79b455429e815f540f88be10c92f68248"
    sha256 cellar: :any_skip_relocation, monterey:       "de7a3afba859c9cbaf79c0c26ad996c79b455429e815f540f88be10c92f68248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f6bc09283e5bc52ed9efd424f8df5435adcd6c7388612eebdfd3db300b108e"
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