class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.23.7/pup_1.23.7_source.tar.gz"
  sha256 "24f49f86affa4780ec9523d462496d400039194182ca1ef32d52474f31c9607a"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86a03008a8eba332dae324fc5a107a128b0d33eddca3839cf381949f3434e8c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d523349d42b58f958754622bb8deb0f14b8338b3353d9ecc80a3efc76305898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db65c4ffecfabaaa9a52035abbb3802dba4b325857dc317673b73f92156718ee"
    sha256 cellar: :any,                 arm64_linux:       "351a9286ff1286651e310504a46d468e0003138adeabb8c78f2ec2df4d5f04da"
    sha256 cellar: :any,                 x86_64_linux:      "74564824a3c1bb2051b4311c6a9163b7fa77be4a847b321a7348867ab583610b"
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