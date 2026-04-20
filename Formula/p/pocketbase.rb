class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "f1c81277aea92d30195b5cd6060b627da40818604fb2d905dfa990b2a4bc59f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03ee94611066f5f7b376dbb5f65e40c7b7bf5155b16c4cbf5a1db9277b36811c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03ee94611066f5f7b376dbb5f65e40c7b7bf5155b16c4cbf5a1db9277b36811c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ee94611066f5f7b376dbb5f65e40c7b7bf5155b16c4cbf5a1db9277b36811c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9fb5cb7579a30fe7902b2b2583941ccdc5e038192d6cf850d9b2fcbbde44e1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb3dd5e9cd988f6ab8c947726b768d3669f8ae7f22369191aae0a35fb01a1cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce81b22e4b9c09d1d623d1140dc7c72f3e315c37d42724bd016f38634215a8bf"
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