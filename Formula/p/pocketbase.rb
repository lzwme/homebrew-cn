class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.37.4.tar.gz"
  sha256 "514a00246e2e7bbda53187c31b51823c5bd18c018b65db85728fa1aadcc91c06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5973dac84c95fb9296db6b25c9bf2c9848c446b004e7e48e40df5a8b7fb246a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5973dac84c95fb9296db6b25c9bf2c9848c446b004e7e48e40df5a8b7fb246a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5973dac84c95fb9296db6b25c9bf2c9848c446b004e7e48e40df5a8b7fb246a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "97051d6348f367e6c7b6e1c70c24369e153725e9691a23905e32ecba02f4529b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29229e392926508bf94d2f7acdc78b7c8f3503b4ff993d399a13e8cea954f408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa16110d009a3d32cbb7f0affd4adad2b45c1ba2517edded812e7fa15212d761"
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