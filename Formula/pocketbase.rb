class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "39c616f073772e041025c80398a261f76491d6370f1ac0cab1d61926d02b9809"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7e0d2ef45a7ddbb4a93528f5d0e5d159c362a52818526dcc46fdc212e1c1ce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e0d2ef45a7ddbb4a93528f5d0e5d159c362a52818526dcc46fdc212e1c1ce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7e0d2ef45a7ddbb4a93528f5d0e5d159c362a52818526dcc46fdc212e1c1ce5"
    sha256 cellar: :any_skip_relocation, ventura:        "5cd09b0407be9c90a12c439a6dd64cd391813f2606a71d582a08bb9135148be2"
    sha256 cellar: :any_skip_relocation, monterey:       "5cd09b0407be9c90a12c439a6dd64cd391813f2606a71d582a08bb9135148be2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cd09b0407be9c90a12c439a6dd64cd391813f2606a71d582a08bb9135148be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417e5bd7176265cf1d1b92ac4d8f4d0195b3bfc9cfc2dc1ab77caa3a9316d546"
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