class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https:github.comNetflixbpftop"
  url "https:github.comNetflixbpftoparchiverefstagsv0.2.3.tar.gz"
  sha256 "0cca2b54308e7cda18b17915c74a564cdd7a69b0273b1db670bc54b01eaab648"
  license "Apache-2.0"
  head "https:github.comNetflixbpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fb8ce78a248225379bc69d7afb28423a79724b032557b99536b731de869e36d3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}bpftop 2>&1", 1)
    assert_match "Error: This program must be run as root", output
  end
end