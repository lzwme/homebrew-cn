class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.26.4.tar.gz"
  sha256 "e1b99718d7544cd641ab531549d598d02ee075dbaba9ac347198ec74e3ab0e5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca8692c168bdd643ac782dcd9d13848dc5f55ef4887d93ebd08b8f616d51c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ca8692c168bdd643ac782dcd9d13848dc5f55ef4887d93ebd08b8f616d51c3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ca8692c168bdd643ac782dcd9d13848dc5f55ef4887d93ebd08b8f616d51c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a480e779e4ec62489b34993e356d387c615dcf4e2f7b35df95c3f1a13c0fd7e"
    sha256 cellar: :any_skip_relocation, ventura:       "5a480e779e4ec62489b34993e356d387c615dcf4e2f7b35df95c3f1a13c0fd7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c49977cbcc7bab13f39b40383a2c0e1076c062e52da296f3eacef35313bd439d"
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

    assert_path_exists testpath"pb_data", "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_path_exists testpath"pb_datadata.db", "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_path_exists testpath"pb_dataauxiliary.db", "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end