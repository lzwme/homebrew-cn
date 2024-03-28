class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https:github.comNetflixbpftop"
  url "https:github.comNetflixbpftoparchiverefstagsv0.4.0.tar.gz"
  sha256 "977694126dc20acd1c57bec506ffebec3472d0397b34ae3dc739cfddefdb693d"
  license "Apache-2.0"
  head "https:github.comNetflixbpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5c73ee50782c21012bb32782328a48961d3614fc9687215c695964a4d8c160bc"
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