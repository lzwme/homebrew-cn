class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.23.4/pup_1.23.4_source.tar.gz"
  sha256 "294b2c5415bb71cd848dfec7dc4d9d21777d4e601c5c8d96af5a9e7e449b97cf"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b061b6c43a694550479a982e8ef3e84b649eea6343afbcde68b17c59b9d833ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fd39188d8b5d5048e8b4389b2917a61d5055f179a8f2c5e3a29af5b7199b032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e5a5d5187ef0f0968e8ec113175749e577e54fa74f5e488a052cf67515ea886"
    sha256 cellar: :any,                 arm64_linux:       "376e98452253768ff057bce2b7d5d6cb4d643e91f5b7d2508a5c0ae06ccb75e0"
    sha256 cellar: :any,                 x86_64_linux:      "f48d5d0e7912ea39ee1d7539513d5732ec90195baa29c4c62fd2a112e1d65639"
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