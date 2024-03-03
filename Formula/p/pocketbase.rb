class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.1.tar.gz"
  sha256 "fa5957ff5ec0553821ddb1c9ff2fb5f9a5e00b10886e16867e04731974fb257e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fef6073ee298344f8a50902fdf7f3f886e3a6664fc4223cf456670867a3adf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fef6073ee298344f8a50902fdf7f3f886e3a6664fc4223cf456670867a3adf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fef6073ee298344f8a50902fdf7f3f886e3a6664fc4223cf456670867a3adf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cbaabc471f3757a349192479f23130af0d05c652dff00a00fbba2b9f7f484ce"
    sha256 cellar: :any_skip_relocation, ventura:        "2cbaabc471f3757a349192479f23130af0d05c652dff00a00fbba2b9f7f484ce"
    sha256 cellar: :any_skip_relocation, monterey:       "2cbaabc471f3757a349192479f23130af0d05c652dff00a00fbba2b9f7f484ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86be7a224191045ae872b2b3ccd579a6cf3850f5d83cee874149c4c0b7b61d84"
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