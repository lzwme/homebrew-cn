class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.24.2/pup_1.24.2_source.tar.gz"
  sha256 "3cd5860f2a143d7365e390b2401fa4a42957cb59200828c9fac3fbe1d40f85c9"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "581ca311c92cd7fa01429844839a08c2c3fc07ba0c4f02945b60118153f01863"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c964706aa810ecbc60e652434971f70075372d6369d864eca5a21736ffac247a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3761ffcfbf620e9b47d5be824b96b9dabdc8767f918324556c3825646e5700f"
    sha256 cellar: :any,                 arm64_linux:       "0c39a24293530a9b7893dd829a6c8291960a57e0970b8aee9d54cb9d2664202d"
    sha256 cellar: :any,                 x86_64_linux:      "0f03047eefaf5f1a83a397b22e4d220fb67f14398ca28896c8e2db39217cf8a9"
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