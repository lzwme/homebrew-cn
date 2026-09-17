class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.19.3",
      revision: "48d76187796f6b691881c518990e4ddf56ee9401"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "f79218bf49cc05256a30418a5e20121feb0e7efd529329cdf25a1c79a72063f4"
    sha256               arm64_tahoe:       "7688aaebf9c2c33bea10f70fa5ed16ac5150a4f6c2cfcc6e5d2319e3c582df66"
    sha256               arm64_sequoia:     "7edf5c081119a64e5d7f8b3b0554fab153f9952447e4e1929475fd9516fd7437"
    sha256 cellar: :any, arm64_linux:       "fe3d971a6130b7c34ca4f244b37e00736045cad38d05160f94eda4e9d0fa459e"
    sha256 cellar: :any, x86_64_linux:      "bbf1aaeef4e3760ec67eafeeeb616976d44890f6fc4307c760bc117e54867292"
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