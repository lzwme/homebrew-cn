class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.4",
      revision: "08090ad71af7b47c1bb6554e4641a441b039776f"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "e6f5fa920081d3dce0ceb77cf31b8294cbbd932f13e99c9fa5fd05e21bf18291"
    sha256               arm64_sequoia: "58bd585edcb6325d2f6afd44896ce0498e0c5e38aed7c4c4d2b70187b0a1878f"
    sha256               arm64_sonoma:  "7600da0b2b1c76675faa7f8c4a8fe68c3bf0f8ea1e9e81e1261d4103946f5bdf"
    sha256 cellar: :any, arm64_linux:   "2d320f80404849a1a7c0abe674188e58a7ed08b7c00869a33e2a80431e235d06"
    sha256 cellar: :any, x86_64_linux:  "38bdd3b7583d63bc98a464be36faa2138833e0d80a0c643543e67775e045b47f"
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