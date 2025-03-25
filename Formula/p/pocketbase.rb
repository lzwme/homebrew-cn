class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.26.3.tar.gz"
  sha256 "5d11011ebe3301ae7a8e981810ec5571be97bef4ff273d01c3dae6f3b17f8fb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84d5e7f0af98f408723cabe8381a118801d595c4dacdbad8588d8ce217a7a3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d84d5e7f0af98f408723cabe8381a118801d595c4dacdbad8588d8ce217a7a3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d84d5e7f0af98f408723cabe8381a118801d595c4dacdbad8588d8ce217a7a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba799215a036354920ac32358e8542dcd21be9de8b8bf0dbd92e821ad97f2490"
    sha256 cellar: :any_skip_relocation, ventura:       "ba799215a036354920ac32358e8542dcd21be9de8b8bf0dbd92e821ad97f2490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5cd7dfa0eb205fbc87dc9317385fe45ae6b0df481559b2c9d792b3321a85cd6"
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