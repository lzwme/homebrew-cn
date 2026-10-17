class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://ghfast.top/https://github.com/jdx/packslip/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "0d56b1059dc7167b12c3d33169a9a61861561ef436fa068e0ea333023f41750f"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea0be159da6e698739c4b47141a72151ebe9c6057c1d3b5bdc021df215f59695"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "462652e65110d729fc3f2167deb37422f2b12a06c9ebe9b0f76afd8002e9b80b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3e63a3250b5abb2b0bf83cc9466f9ffe523cf83b29534358c11af581fe56b61"
    sha256 cellar: :any,                 arm64_linux:       "7d5e84883ced7bcd9bb8072613ecc6703142e2c96c693b7a3ed41dd5ce9da119"
    sha256 cellar: :any,                 x86_64_linux:      "b34b1cb295db32a11eb0f96761191942c171207a75848359fb9baa4591a58d3f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"packslip", "completion")
    man1.install "packslip.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packslip --version")

    system bin/"packslip", "keygen", "--out", "brew.key"
    (testpath/"brewtest").write "brewed"
    system "tar", "-czf", "brewtest-1.0.0-linux-x64.tar.gz", "brewtest"
    system bin/"packslip", "create", "--project", "example.com/brewtest", "--version", "1.0.0",
           "--key", "brew.key", "--no-log", "--url-base", "https://example.com/1.0.0",
           "--bin", "brewtest", "--out", "dist", "brewtest-1.0.0-linux-x64.tar.gz"

    output = shell_output("#{bin}/packslip verify --pubkey brew.pub --allow-unlogged " \
                          "--artifact brewtest-1.0.0-linux-x64.tar.gz dist/packslip.sigstore.json")
    assert_match "ok: example.com/brewtest 1.0.0", output
  end
end