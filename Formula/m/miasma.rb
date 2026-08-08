class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://ghfast.top/https://github.com/austin-weeks/miasma/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "dbd294fc9a2c4544ee93964e071743af1961a5ac7e6e332ff17ff3f27e1a6fdd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba38cb599385c575bf9dc96000abdb270c566443d3fecdad2c7c9391b111b25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e283b0a8c9ecf4b73f65522e42843b1c992b6b63523297dc3e305b4ec61572d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a14a6d4a80e5a1fb4008c1431abe432d8d4c98b9cb145f37a91af4f538db2cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ceba111ffd3f508a640e6707f5e0d7a496d39afcbfbbc10965c1631c94362c"
    sha256 cellar: :any,                 arm64_linux:   "66f18f1b7169a6f687381ea67d382c570903ba7677964b1a4a7706d71d7d708d"
    sha256 cellar: :any,                 x86_64_linux:  "f3f87e78eab54ce399694a78cbb7689108f9b3ad6fb54bc1c766e57ccfb686dc"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end