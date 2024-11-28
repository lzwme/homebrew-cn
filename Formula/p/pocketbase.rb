class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.2.tar.gz"
  sha256 "4b6ef8ae94869d52cbbaf575fad55fd7571c9c7a7f8783872edff7073ad97c74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c68604536330a319b4cc3d6f61cac4196833c944bf634128cca013207a91ba0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c68604536330a319b4cc3d6f61cac4196833c944bf634128cca013207a91ba0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c68604536330a319b4cc3d6f61cac4196833c944bf634128cca013207a91ba0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbc3751bdcd05d29af7e053bc0c051f31ff2db91048680657e50563c010091bc"
    sha256 cellar: :any_skip_relocation, ventura:       "bbc3751bdcd05d29af7e053bc0c051f31ff2db91048680657e50563c010091bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf6ff906da28765fd56592019bf21709cebf1044d33f7189c548350553905bce"
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