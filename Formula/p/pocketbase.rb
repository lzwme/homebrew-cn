class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "5a707556b34793a553718328f7eb2c9d4fbbeeb7c94f8de2d9e0652a023ecfa0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7209a5dd813ad92a23ab46a194371e5b9edc8ace8c2f821e3a9ae8c71340b7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7209a5dd813ad92a23ab46a194371e5b9edc8ace8c2f821e3a9ae8c71340b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7209a5dd813ad92a23ab46a194371e5b9edc8ace8c2f821e3a9ae8c71340b7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1e9927278b229684bcb0cf1fbe608bfacc9e6b6f7e8f52a7419c5a37a81e909"
    sha256 cellar: :any_skip_relocation, ventura:        "e1e9927278b229684bcb0cf1fbe608bfacc9e6b6f7e8f52a7419c5a37a81e909"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e9927278b229684bcb0cf1fbe608bfacc9e6b6f7e8f52a7419c5a37a81e909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0583eda6caf3912af5807e3fcfc62833825e5a66829e193c4367466d2716f75"
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