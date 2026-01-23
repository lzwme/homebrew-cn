class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://ghfast.top/https://github.com/stellar/stellar-cli/archive/refs/tags/v25.0.0.tar.gz"
  sha256 "2c93fc9936b8f1ce73f689b0bb257f363bdfea1b4df561c207082d5b48d7c3bf"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01d1622760af23560d581f76972d6497e8c096221e3ce45c6e2672dd13f11955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd6be9ddf132f3bf108188d2478f989ee4a63b6b6fc20ae7bef2ef6f1dea50ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fec9a0df13c3b48f54b2844d7421895fac0c12e3be03c90844711f8372c2791"
    sha256 cellar: :any_skip_relocation, sonoma:        "a65637b6ebcb0d7aa6f455348368c3d1e8b3cede75f3dbdca75afde6c7722a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a474b842de01de62226024ca3017547544876e16ca8cba9de7b2076284050e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4cce6557f718a59c1d8bbdf5d2e075c23322186f1677fb8a7a7579707943764"
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