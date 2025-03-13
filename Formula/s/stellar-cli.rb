class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https:developers.stellar.org"
  url "https:github.comstellarstellar-cliarchiverefstagsv22.5.0.tar.gz"
  sha256 "92411c736a2289306af872efbf9078639627684ef85cc9237b3d5994d477a70c"
  license "Apache-2.0"
  head "https:github.comstellarstellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46fe154d3a4f8ecafc0ba9403f0c378e778ef7f9dbc914ca2e9bd1e7d47d779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fdd7d3caa0a4a8dbaf16c43cf3ee71de737b31dc3e6e74f7c6a714eff9b4885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f063c7f4edc764fec0629163464641587cb63ba33112a5081becd23648e7fdc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca60fde087e6014e1d16122db3ae8c66e41e2e2ba02a84153357323632410d00"
    sha256 cellar: :any_skip_relocation, ventura:       "669d4c1088737ee76529fabe98588ad75d96c728efe78ce2c5219c35f6cbaf68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e08f51b1f1d65a20200a273ef18cc36a2fb537a503fc8d15cc638bd2e3881f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmdstellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}stellar xdr types list")
  end
end