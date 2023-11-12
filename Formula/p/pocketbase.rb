class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "bb6a2e270b07c42fbeea9c3dc099686a2f12db56b0e5bbb8f35f43f2b7bfbeaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8fa4f8f85dc5fb8877a56c8f7115960e43530289b4ee0e40266f395fe3d7173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8fa4f8f85dc5fb8877a56c8f7115960e43530289b4ee0e40266f395fe3d7173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8fa4f8f85dc5fb8877a56c8f7115960e43530289b4ee0e40266f395fe3d7173"
    sha256 cellar: :any_skip_relocation, sonoma:         "120625f8b06637ab06cf2997c634e019e8463ffd245a3570bdea30f46a558319"
    sha256 cellar: :any_skip_relocation, ventura:        "120625f8b06637ab06cf2997c634e019e8463ffd245a3570bdea30f46a558319"
    sha256 cellar: :any_skip_relocation, monterey:       "120625f8b06637ab06cf2997c634e019e8463ffd245a3570bdea30f46a558319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bffef0d2e76f74926f3e518c14b8bf28ba563c381b83654cae7f09b139f35fcc"
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