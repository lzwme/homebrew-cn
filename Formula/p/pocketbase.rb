class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.8.tar.gz"
  sha256 "a5c15814b11aa54e752c066041259341f74dea742f310de0c62359342d8dadf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "350ae08da1e678a52a67ec17a93229ad3111b202c075ea57cbe60a761acc9462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "350ae08da1e678a52a67ec17a93229ad3111b202c075ea57cbe60a761acc9462"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "350ae08da1e678a52a67ec17a93229ad3111b202c075ea57cbe60a761acc9462"
    sha256 cellar: :any_skip_relocation, sonoma:        "1595ee8f48ddb71e08ce311b73c9cdf4839c3015f68c10a744a1104f925b6674"
    sha256 cellar: :any_skip_relocation, ventura:       "1595ee8f48ddb71e08ce311b73c9cdf4839c3015f68c10a744a1104f925b6674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77f8288868a857ecb44aa506e8b20a607ff8cf5ac8634c686d99e70cd5dfd560"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.compocketbasepocketbase.Version=#{version}"), ".examplesbase"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}pocketbase serve --dir #{testpath}pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_dataauxiliary.db", :exist?, "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end