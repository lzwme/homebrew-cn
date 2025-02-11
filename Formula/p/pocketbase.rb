class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.25.3.tar.gz"
  sha256 "3aa8b66ffeaefe8aa6a0b358bf2a490cd4e91d9936431ed5c4b72463a5cf9287"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deae3d564e47417d5aa143eb6b0bb905ba9717df8d395d9f992252bc2f317daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deae3d564e47417d5aa143eb6b0bb905ba9717df8d395d9f992252bc2f317daa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "deae3d564e47417d5aa143eb6b0bb905ba9717df8d395d9f992252bc2f317daa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a45c38d899eea43c35305fe0a8e319c893f1d9394291e70132fbe27ce00eb9ac"
    sha256 cellar: :any_skip_relocation, ventura:       "a45c38d899eea43c35305fe0a8e319c893f1d9394291e70132fbe27ce00eb9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9693e2a0cda3d710592eb5714cead15e78ac4076bd727339075c90d32754adec"
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