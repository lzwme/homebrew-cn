class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https:developers.stellar.org"
  url "https:github.comstellarstellar-cliarchiverefstagsv22.0.1.tar.gz"
  sha256 "5645295b59dad15063c8c3b7d8e65cc08d6c0e0e1f409643500ebb97e98d6908"
  license "Apache-2.0"
  head "https:github.comstellarstellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62bd031de38570dc607ae126aabdc7ade4e448c25adb7776ea1e6f241125fda4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a688637e85f16d662edef04092a8da1fe7175b9e80e594ba50bd49d187929a14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c4c7953aaa9bdade0ad04b30bf5f5ee374a7a7e984c3e585afe740da5504c85"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2fb8ac91f1d59d130b5b4ca740bde54918284539df76a42cfea022fe3c0671"
    sha256 cellar: :any_skip_relocation, ventura:       "0d03ea1e860dd0f67a45a1614890002416d44e660630933552a7b52150df63c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c49ce81d7e9675f1709d32045536affdfccbf14814e763e258eebba5aca48832"
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