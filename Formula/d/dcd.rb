class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.18.6",
      revision: "f7fbd3856b5b9762cf2e5a6f2eaa44657b4cf1db"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "e325fb9e74ac4f66cd928326d12f328be7b6daad66e72b81308e05668e2334f5"
    sha256               arm64_tahoe:       "9ac46fb2721804db4ef955167dbcf21fd1bc5b17adc5919969f4a194156bc131"
    sha256               arm64_sequoia:     "8fcd316eb1c9e3919f1370700d4b55660a28874c46f4bc50886c916cbbd87f94"
    sha256 cellar: :any, arm64_linux:       "a574de92c137a359158644fa0ae1f3d399525e51711d729f1a193a8875ea2e1b"
    sha256 cellar: :any, x86_64_linux:      "4824f7673df5e5b564ccf566799cd384417772da08a010b2d684565b7291fe1f"
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