class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.27.0.tar.gz"
  sha256 "d6cb74d6ca6aa6a5be53a4e8a25e2d48852b24d84204884bd66b3c23fdc5d687"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e15ab25186892f46344d2c469c0d5bc549204ba32064dbdf852b94ad98ecd92c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e15ab25186892f46344d2c469c0d5bc549204ba32064dbdf852b94ad98ecd92c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e15ab25186892f46344d2c469c0d5bc549204ba32064dbdf852b94ad98ecd92c"
    sha256 cellar: :any_skip_relocation, sonoma:        "736b94673d10aebea7191083855cc4925b2dcc89a16e4036b1d2e4c36fab3cb9"
    sha256 cellar: :any_skip_relocation, ventura:       "736b94673d10aebea7191083855cc4925b2dcc89a16e4036b1d2e4c36fab3cb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e924451fc8b42ad228c9f490faa3857af884072a3daf396825b064ebfff096a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45eaac0819d34942b07600c5a972aa71315a3106f1ca92248ff7b6b284f79769"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.compocketbasepocketbase.Version=#{version}"), ".examplesbase"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}pocketbase serve --dir #{testpath}pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http:localhost:#{port}apihealth")

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
end