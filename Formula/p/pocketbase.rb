class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "74f500147d8e41047e5c7ac8127e8e7abc2acc38dd176334fe50b8cf91099495"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4535ca43ed2a3edd2a4045ad14704d2538f75f2a45b1a53b395ef2975a75227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4535ca43ed2a3edd2a4045ad14704d2538f75f2a45b1a53b395ef2975a75227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4535ca43ed2a3edd2a4045ad14704d2538f75f2a45b1a53b395ef2975a75227"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7c1f5703228f55b9717a11f11b62645153dd5ac4e6efe1b100d1460a30b3e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "448fa329c018c581e629fd357d9f31380bde2684e1a1b7e09c687722f0b18de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c37c08a6ff681121cf349020fded60597d579f625a4fd97ebddbb426804a4e39"
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