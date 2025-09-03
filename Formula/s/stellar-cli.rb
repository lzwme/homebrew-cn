class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v23.1.1.tar.gz"
  sha256 "affd114d4736b7b47005d463f61e312499bf3541d5ca1ea7bbf27e917c1ba40b"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58b41b37a68e07a6ab8fe6ceac85cd459c7892d5c9bb1bae811838c58b0dd3ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bf14b6bf0899e0cb1d5b69aea889461806296d425d82e6e6305045312ea1e8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7901c974eb6e0438bfebf110c6d71ebe5be8418647086d5a8b6e108365485dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0098f5e49e9f565b7688befd4c0904f7658405c2668474eb39014e3c749de4cb"
    sha256 cellar: :any_skip_relocation, ventura:       "96a1f45429b267f21dd520fd29ecdf8995658054fa677d2abb5d5647bf8011de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6985ab20ca6d0833ed87a182347fd5b6d1e71c6fa1122fb4996b9fdd0b27646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d51770b08ee33fe504d50d372b6b0764f9403f373a3c7598d343982e3a241aa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end