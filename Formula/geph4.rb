class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://ghproxy.com/https://github.com/geph-official/geph4-client/archive/refs/tags/v4.8.8.tar.gz"
  sha256 "30f67f1bcffaed1e68d24a489b195faed8f4242bc6cfc488f5232fbf16376596"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c7ece7e4f6042bd8f52711e49bb336a0122ba759b546b0b5548bd72655bacc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65475c24546905598427059adffbd4aec8d548aca34f7caf348865aa5ec7a93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58c0d61b8c87f72357d363f344d22a9036a3983bd459f6da3ac056a8b00f4005"
    sha256 cellar: :any_skip_relocation, ventura:        "ce5a6d102f3e541e5aec7e7cfd000261a8ae2263b5aa853ab31cd326308cb9fc"
    sha256 cellar: :any_skip_relocation, monterey:       "70bcbe5408046780ed507b04feb4bbb71eec9e01a3835b7fdd56ef5c746097d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d0dcbd3ff81795ec5836460ac52c731eb69600cd67d5c4c9b1521367ecf302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723448170cd162b746ca2166520115e92b78b7ba2e417ef32012f5f118163e18"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end