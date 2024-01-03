class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.14.0.tar.gz"
  sha256 "91039bf2d4ff204e85333afde98a4ca43d694698fa01e82315b3a3cf2571834b"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2c76b53295c491d04c310373cb3a2605d96d4b11a38c6c13e628e2b6ea3bdf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcae32cb5d837a9c2dbf8fdce4a49fafa35894a7abb78cd0c6419e3d07d11b42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74e5e021b439c3eebfddd9776bd35279a6681ca36b99b7d4c27d423e4833e587"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f886b5fdcf77ff45cd55762d6a5c3be0b35463a58a9dd8620797099413b39a3"
    sha256 cellar: :any_skip_relocation, ventura:        "3bb25501543c740fdbcfa04e04afe4bc688c8565386f24e79958893e7c9072b7"
    sha256 cellar: :any_skip_relocation, monterey:       "219b92a9f625978fb0dd4d6c48b6398db53ac08a264b88fdaa19c7c60f7a1461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32482be8efc76448a5b0bb7857987f7b874d6bb98be96c519be0efb50c4a21a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}ord --version")
  end
end