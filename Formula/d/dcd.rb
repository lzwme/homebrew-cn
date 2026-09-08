class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.18.2",
      revision: "a936ce614c98dcfc21da1900459290b775cd1399"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "78fc97312ffc9196c5d2b741841861951f4f4cb21a7b45a854c0533585710e24"
    sha256               arm64_sequoia: "d008a7280d994ec06e34867f9bd152dff2aebe7275d202c203835dedce0a8008"
    sha256               arm64_sonoma:  "5b3fd6cac545338ce50bf72de4a505c7e3438e4e68027c0531fc1c54c796b7e3"
    sha256 cellar: :any, arm64_linux:   "a751b3c5e178004a5c4865729e520d32584f96130363dfb58118ae08d5f4b741"
    sha256 cellar: :any, x86_64_linux:  "72de846afd51f333d1223e37a4a7008226bb301ecde0676be17848fc92b1b896"
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