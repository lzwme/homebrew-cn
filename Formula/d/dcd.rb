class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.18.9",
      revision: "9b6ee5d14a0f97bd4b5e2cf0f4c89b257b4d473c"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "f4d3fa9d331b5132691ce8755cd5e73169b9acc864a37986948921bd9403cb53"
    sha256               arm64_tahoe:       "8ce5f300194818cd68b575497d82942fbe79a5535521dab05203bca31acb447f"
    sha256               arm64_sequoia:     "19a77bbff0f98a247f9c3974c372dbf7879c8994caa2e78aabf50245209f0556"
    sha256 cellar: :any, arm64_linux:       "a64e9c8185f0fd9075ba21479095662d4daf8547c66501c855556ea4eb10407a"
    sha256 cellar: :any, x86_64_linux:      "2b81a1b0270d36822eb446d830b266b240732723049fa0c3ddc495a49b458c7e"
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