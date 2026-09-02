class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.0",
      revision: "10be6833e8f0ed8d1fc541fd65a3b5ca67b2a158"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "e4ec3751e6dcdca8e79e86a375b7ac778ba9738673b62143ad4d23df810cf604"
    sha256               arm64_sequoia: "932c00179513ea02eb91de22d5081a9254ae1e9e96c8dfc56c129306e009f132"
    sha256               arm64_sonoma:  "365a06bf4ad5e62f8c99efb89d51e41f737eebc45dd8ff4084c078804ced7367"
    sha256 cellar: :any, arm64_linux:   "6a1eb5522b2c988ff8550201d771c9cf8be968343091b4975d756a7979a4b049"
    sha256 cellar: :any, x86_64_linux:  "2f233f4a75eebfa689a349bd0f1dd02a1bdd388e780a3b4630791d3579768ec4"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end