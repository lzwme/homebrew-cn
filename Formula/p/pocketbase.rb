class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.17.tar.gz"
  sha256 "d2e30d8417cd16dda5faefbb4c8b1942c86264cbf82104f4c516a972e1d3b1e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e2960939663b8ab603ffc4d59663efac691897ebfad88745e19e7da09d43b02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e2960939663b8ab603ffc4d59663efac691897ebfad88745e19e7da09d43b02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e2960939663b8ab603ffc4d59663efac691897ebfad88745e19e7da09d43b02"
    sha256 cellar: :any_skip_relocation, sonoma:         "759511327f7ae622a6e33cbe68d09b405b69879c186ca7a100bb07108ab450fe"
    sha256 cellar: :any_skip_relocation, ventura:        "759511327f7ae622a6e33cbe68d09b405b69879c186ca7a100bb07108ab450fe"
    sha256 cellar: :any_skip_relocation, monterey:       "759511327f7ae622a6e33cbe68d09b405b69879c186ca7a100bb07108ab450fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75314b000cf777f91745b7f8b3d0e01034dcb49bcb9641b62f666133c78767d6"
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
    Process.kill "SIGINT", pid

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_datalogs.db", :exist?, "pb_datalogs.db should exist"
    assert_predicate testpath"pb_datalogs.db", :file?, "pb_datalogs.db should be a file"
  end
end