class Zoro < Formula
  desc "Expose local server to external network"
  homepage "https:github.comtxthinkingzoro"
  url "https:github.comtxthinkingzoroarchiverefstagsv20240828.tar.gz"
  sha256 "8b41550a1d42fa2c0a67d7115978efff126ab6fff30d774ce902febd0b682c5c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df2261266bc3c20e94bf8ccf0611f1b23bc08caf4310dc9c7d1045549bc03dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2261266bc3c20e94bf8ccf0611f1b23bc08caf4310dc9c7d1045549bc03dda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df2261266bc3c20e94bf8ccf0611f1b23bc08caf4310dc9c7d1045549bc03dda"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5cfca2c2aec505f459401d026a5a3d38ad66e772c0470f626215719480a4b6d"
    sha256 cellar: :any_skip_relocation, ventura:        "b5cfca2c2aec505f459401d026a5a3d38ad66e772c0470f626215719480a4b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "b5cfca2c2aec505f459401d026a5a3d38ad66e772c0470f626215719480a4b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd81e60c2c5cd3b30aaa7f8dc372f435a73ff8cb765f77a04c0fb9fc0c3874ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".clizoro"
  end

  test do
    (testpath"index.html").write <<~EOF
      <!DOCTYPE HTML>
      <html>
      <body>
        <p>passed<p>
      <body>
      <html>
    EOF
    zoro_server_port = free_port
    server_port = free_port
    client_port = free_port
    server_pid = fork { exec bin"zoro", "server", "-l", ":#{zoro_server_port}", "-p", "password" }
    sleep 5
    client_pid = fork do
      exec bin"zoro", "client", "-s", "127.0.0.1:#{zoro_server_port}",
                                "-p", "password",
                                "--serverport", server_port.to_s,
                                "--dir", testpath,
                                "--dirport", client_port.to_s
    end
    sleep 3
    output = shell_output "curl 127.0.0.1:#{server_port}"
    assert_match "passed", output
  ensure
    Process.kill "SIGTERM", server_pid, client_pid
  end
end