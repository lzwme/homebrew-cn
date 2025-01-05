class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.24.1.tar.gz"
  sha256 "943581d372f294d61ff2c96ca7b9ac73aca27121f89b5cf64a71d4b928f944b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78f50ae432dcf1933bf612c8f4f8441e2989fe15ded2f5286d0836174720951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78f50ae432dcf1933bf612c8f4f8441e2989fe15ded2f5286d0836174720951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c78f50ae432dcf1933bf612c8f4f8441e2989fe15ded2f5286d0836174720951"
    sha256 cellar: :any_skip_relocation, sonoma:        "761d49d08ab7b4a785e665ea8e836b65bf7e0053367a39b35bc7a2a760224a49"
    sha256 cellar: :any_skip_relocation, ventura:       "761d49d08ab7b4a785e665ea8e836b65bf7e0053367a39b35bc7a2a760224a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "925a45096335d101011093d33d1286c5a8d05a6cc8091f7e1b496278399f39a4"
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