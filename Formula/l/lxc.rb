class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://ghproxy.com/https://github.com/canonical/lxd/releases/download/lxd-5.19/lxd-5.19.tar.gz"
  sha256 "4edc371e8c7e19fa08f1d1362a96761d44db94e3c5054b3adc8051235f250223"
  license "Apache-2.0"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30bbdcfa31e4ad77d72a8e5f5487d05a1e9c89ecd8074bc8afce4eb52fae8940"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1a4c74e234ebf5c6e161a7a7883c632afafe74b98118cbec9af2b02154b0dec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "869df5ab05da79dbd6ed189423c119824d0fe760fc33e23fcb4fbc8206a5ef98"
    sha256 cellar: :any_skip_relocation, sonoma:         "acaea9d42ac41835ac665ed1f8e859921374a8a7b391880c69e5b9a234c5b615"
    sha256 cellar: :any_skip_relocation, ventura:        "776895f060e9bffd3d88d5d33784dd91f7c3c9b9d3d96751f94c93918f62b194"
    sha256 cellar: :any_skip_relocation, monterey:       "da3f538c4e4c4ed19f4f682cdfa31ded58e668e37cc8b3d1da2e182db335d0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b18251f5e267dbb4d1799c8a3b73904ab5d3c2d0371e1ec6453cd82a3d90b2a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end