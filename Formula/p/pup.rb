class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v2.3.3/pup_2.3.3_source.tar.gz"
  sha256 "01a995bc664d846d35eef00a747c277298aff6c5949d3ae77a8a1011bc68f0d4"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c65212a28d99bd98891bfd44cf961ba01cb7ad2681036dcb35a2e499ed910e90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d9a849175ae4cefed14496e76305337f3118028bd486cfe1c6074a47197a4a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f3a1b5789fa2ad965c1d80c8696da75e861f01573786fddb718c7c7bc1e8d18"
    sha256 cellar: :any,                 arm64_linux:       "b25bc0f0eac05394627fc439bfca2dfdf2ec43fa821c2a6a1e1371373c04affd"
    sha256 cellar: :any,                 x86_64_linux:      "9cf81a3edb4f2c85fa332721c5e53ed8ecbba8cc743afeb3840d3c80fca28c2f"
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