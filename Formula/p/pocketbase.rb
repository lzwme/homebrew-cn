class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "c6118d42f5ba569b6ba983a40118075fd092e7336d400cf7b8a8439db83d73fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1635678949837bb02ca1a02ee11d9c86dddb1cb4f347aed925cd4adb64ccccee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1635678949837bb02ca1a02ee11d9c86dddb1cb4f347aed925cd4adb64ccccee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1635678949837bb02ca1a02ee11d9c86dddb1cb4f347aed925cd4adb64ccccee"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a2485fec0d65af24b719f99ac0ccd0cd4f277e9c39b67d52b6ccda54a251e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933cfb21062a271fedfdac8a1c5f9e3183080fcec77ec135c2bce6af5c46be9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "707da9aaedf13b71acc271ee9b0bb61dd0595d9c54922ef12feb1b4211d46c1b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end