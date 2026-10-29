class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://ghfast.top/https://github.com/jdx/packslip/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "83d33a0ccd8ed1c41f850d5b499b412bc8770e017c8a8d9220af428ca2ff1681"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52a7237c81242adffe98d70ed0bf2cd8332ff10bab229c450fd515c603e08a1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aca7fcbc44afdef3a8af6c6c0ae16f332bc43d7decf497538ab47cc987f07942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2395a00882ec2db4ba755dea67b26bf71c2515bf4295d26ac047a51fccc330f9"
    sha256 cellar: :any,                 arm64_linux:       "6c19f1b2c2d7e69394eb971a338086cb68cd7031cf7619dd11ce07bbf5584b55"
    sha256 cellar: :any,                 x86_64_linux:      "6d6fd9a74c8558071872c3aa482325f67f690abceaa041b2a023b5e6e97154cb"
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