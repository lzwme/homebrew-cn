class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https:developers.stellar.org"
  url "https:github.comstellarstellar-cliarchiverefstagsv22.1.0.tar.gz"
  sha256 "6f5303ca1d88e173fb2952b48dd2b88c711bb525b8c2ff5b65f870f08192ccd4"
  license "Apache-2.0"
  head "https:github.comstellarstellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd89adce23bd1938b5e827a29a215fdef70735e28ae159067b138ef42c263304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8884dd1bd6f38eb24b702c1f192edc5e58fb4a4d341a8ea0fbaf57c0133f2a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "109348141ab93feb4fb30fa8140e2b52b65e0ed8e6982b5053a6a665c43a7193"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2734c1426ec3fa7554f00d2efe00ea41e6001d645475b5b1423c1c930fbdc19"
    sha256 cellar: :any_skip_relocation, ventura:       "1cd8a257fad93ba8d47013392d5ccdb96b81ba9f1fc1fc6778f1ba0989a36e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aaf58cc52e40f52aa7d6ced3a71e7badc36e48da525bfd282a01a64359c8434"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmdstellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}stellar xdr types list")
  end
end