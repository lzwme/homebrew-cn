class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v23.4.0.tar.gz"
  sha256 "6bba70b31ba1b1cbaa37ab6c0db350d34d759f03b9767cb073314c0157474ca8"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51a42c455a1c3c5ae5946abaaf302f309ca9451ab25c98579bc6cb24ffcf5b4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e440c153d9760dbc0763e9dadd4e85a35ddbc5d1c5ba679a96e79099cd54f0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e45a7b485ddbb3ecc541378d9a55ffc3376ddd69c55da9c4dc89f4a7b39025f"
    sha256 cellar: :any_skip_relocation, sonoma:        "289769d211ae75d7834adf4b5855c1cad7113063a111fc249ca411834d5b5eb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfd2d8bd8510ec3cb77880594dddc2a2bbc60964114ce2127d3358e0c77f1626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291a28772a79d76e51478673349606c0c29e86d8c04376dc3bf57b06b2508f4f"
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