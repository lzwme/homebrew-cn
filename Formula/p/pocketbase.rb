class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.26.5.tar.gz"
  sha256 "cbed66483a180507149a4eb34ebad9a7f61b836e38d20ab64689de9a2cda3ee4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f3b789d65f9e1144816e81cf4d8b6cb5cccfb7de2feac3ee29bae7a839e942d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f3b789d65f9e1144816e81cf4d8b6cb5cccfb7de2feac3ee29bae7a839e942d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f3b789d65f9e1144816e81cf4d8b6cb5cccfb7de2feac3ee29bae7a839e942d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ab592efb5dc4bb3d6755ba278b9af732d1a4a955e51e95be4a46288f2742562"
    sha256 cellar: :any_skip_relocation, ventura:       "8ab592efb5dc4bb3d6755ba278b9af732d1a4a955e51e95be4a46288f2742562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcce0f804721fe53db8c91cdfd1fa460192e3548743c194af6346cfbc5686bdc"
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