class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "31bb1eef0be00002202eee6138abad60ebef9b1c93423448a7df4868fd29ff65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "693cb845b7406bb6f23910a9460ac5c98c7d111efb8cc3b169aa04ac3a721b3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "693cb845b7406bb6f23910a9460ac5c98c7d111efb8cc3b169aa04ac3a721b3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "693cb845b7406bb6f23910a9460ac5c98c7d111efb8cc3b169aa04ac3a721b3e"
    sha256 cellar: :any_skip_relocation, ventura:        "0be2acaa4510d4c71aa9011f378a88f7b330fa83e16c8ca9a8812c0a4ce4b2f6"
    sha256 cellar: :any_skip_relocation, monterey:       "0be2acaa4510d4c71aa9011f378a88f7b330fa83e16c8ca9a8812c0a4ce4b2f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0be2acaa4510d4c71aa9011f378a88f7b330fa83e16c8ca9a8812c0a4ce4b2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e152bdbaa0c7c65cbc2e8ab8c74d3c64ef2ac4087ffb8740dc3f5133658f02"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end