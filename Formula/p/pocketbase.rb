class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.8.tar.gz"
  sha256 "4cecdc89f86f19291dc5f5f4bb86707fff4fb5752bb269aa78348c1b4b37aa72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad665277e12239bf383f47049b22a96fc328918c5665cf963f20c7baeb190f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad665277e12239bf383f47049b22a96fc328918c5665cf963f20c7baeb190f49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad665277e12239bf383f47049b22a96fc328918c5665cf963f20c7baeb190f49"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f0d7847e71cf4d41e73870779ad6eff5f8d1227d984f7cfa8a25423f8700f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e588e736b4e138a9fee9d5cc3f7703027b5f06928150f973dfd2782a9cd5ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52d572d270007c9fe416a09a764055af6080abb0fcc25c3c7c83549effc7313"
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