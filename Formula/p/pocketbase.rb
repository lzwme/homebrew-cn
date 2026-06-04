class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "7757b4222df46a292a5eece0a705c2c1f5b6e05681f0f9ddcb13d5ff06b2b5f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49433d085e0176c591eee00920eaa452db50cf23cc3d9598ce66d141c8ef046f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49433d085e0176c591eee00920eaa452db50cf23cc3d9598ce66d141c8ef046f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49433d085e0176c591eee00920eaa452db50cf23cc3d9598ce66d141c8ef046f"
    sha256 cellar: :any_skip_relocation, sonoma:        "70ec184d9b4042e13f5088c1861d6edff9be1625be4145bd0576fc429b760957"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faeea259c8e16221a69c56573d9f41b361a501dd189840cda6a294f28d5bbd38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579c571eb9bcee301345da0f6de7f36b97729572f96ecafa890aff30190df4e4"
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