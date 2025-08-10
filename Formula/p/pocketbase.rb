class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "adda23f18402927978903b56590d71082dc3bce55543ba7df1a7e951bb0ef8b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8bc2fa06be554252f6ff7065cc64097b4f7f57432052de060c1966fd99f8be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8bc2fa06be554252f6ff7065cc64097b4f7f57432052de060c1966fd99f8be2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8bc2fa06be554252f6ff7065cc64097b4f7f57432052de060c1966fd99f8be2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c15ece4f82d7a08c65f2317daf08b6a905b2c7f4144a6022fc5aa9bd665045"
    sha256 cellar: :any_skip_relocation, ventura:       "c9c15ece4f82d7a08c65f2317daf08b6a905b2c7f4144a6022fc5aa9bd665045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e32b6782c541e676aed46cd7e40addff79aec0f54aa81bc09bf07930e723c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d198450092b6de2e7b87ef9a435fdd0199c78dc684e376c5e26625a3acdb1e"
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