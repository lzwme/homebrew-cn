class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v2.0.0/pup_2.0.0_source.tar.gz"
  sha256 "7e750ec41f780fd7059b7e236f88cb8fe9f7b33721c1535d4b4f839443e933b0"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2235a9759684b4e1674d898a6bdf20ce81fc28fbaad647383da96e9b5292d213"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9aaef01f37fbb6544d289143e462f04bf0cb431dd15a6477f968d74a3773d11f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15345a8447e0568b865554a2b2081b549ea7fa14939e1713c453f8adbe0bce6d"
    sha256 cellar: :any,                 arm64_linux:       "f9a0b68f7ffe4c22e719e4b3b953fd247f1d87eaaa3a3d2819fda3d236386400"
    sha256 cellar: :any,                 x86_64_linux:      "957bc6e829ce77559ce1a46d3157b7c67bbb3a8a3492343ae34c1d3ece790b1b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end