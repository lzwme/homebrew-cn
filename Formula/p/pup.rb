class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v2.3.4/pup_2.3.4_source.tar.gz"
  sha256 "ed41170d96615869c7218b7ef18637d522bb1424220ee52ee6b7946af2e229b0"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "220fa36f2b0f1d00fd87288dba9be72703adc2d36554bfccea14e29b99ee54cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "caa69379f3c809834a57c05c400a56b365081510e47a034d24ab7ab75242e5f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35e92abbcb756097e2a77ca58db763c539c9603e758a817b447c110dc8d8ae3c"
    sha256 cellar: :any,                 arm64_linux:       "bb1c872d01d2c77c7975c7e6c33c4b5c18ac38d5e39b816e54a6d4ac1993cd81"
    sha256 cellar: :any,                 x86_64_linux:      "2e28d5fbb5cd47bc4309314cef2f5f2cf7f440a2c8c821a0ef7e3f2ed6c09690"
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