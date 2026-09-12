class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.18.3",
      revision: "9da9e7bd289bce83f75252e7873c66ad0beea2f4"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "37a1707e339174c429cb7b715517b56cc9fe3eddf788eee7978c17fa1e102318"
    sha256               arm64_tahoe:       "82fcf8824fcd5abafec60dbb999856809798fa782c1f8294d9b66cacba91ee9b"
    sha256               arm64_sequoia:     "bce7e9f5c10088c0771050fc2e4f58daa34ed633c45ce07dce7bce3fa6140f9b"
    sha256 cellar: :any, arm64_linux:       "3ad2f6bf0bdd32da6e96c7811fadfd0b413c73118763fb0bbbefc4372b5dce3c"
    sha256 cellar: :any, x86_64_linux:      "c39a3b7466f20a5b667736b6ac53a2bd5093f82f304b8c187adb2ee5c265663a"
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