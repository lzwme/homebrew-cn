class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-28.0.0.crate"
  sha256 "1772d04d1bcd1bc3d2aae81932f3dbad84bac9fdf8b4c76b72aa4eb11394ae64"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5b0a5010dc03611779a9f69f397e6520fcbc7743580177ddf89d4943e76eb59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1977986042e891e2f7686eb7d4dc0a367b83e035e24d29ed371ad99724e995b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51de3f5ddb063675ce687e5fb8588fd6c340227207d6e36dc080a6f299bf0bd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e2df62c39ec584fdd52184f097cbfd4e12207f7ee155783ae05b17ae3552fc4"
    sha256 cellar: :any,                 arm64_linux:   "b9af446c2f2b0dd02e4fe8df81f6512f0dff1a4a9539bd567962e475b2393e22"
    sha256 cellar: :any,                 x86_64_linux:  "776275dbe66eedc75e75e41e39b644b16f95c1abca3098e5cb36ec17ef70fe3d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end