class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://ghfast.top/https://github.com/jdx/packslip/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "b2be7039ab521d2d08d6bdc6e1383f4e32e9f1cc21242f52772b4db09d1ef67b"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73196d63c55c61b7abc5f806d5dbf5cbcbe45f25cbab576e795d8a71aa278086"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19340c3d83f38862baa5bdbeb6c68a2b1e8cf103eb8b0d04422b5089f8d32cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f065fb0845e41fc3f79be66149a0479ca64170e1a6d18f3bcd43b6482ceb2138"
    sha256 cellar: :any,                 arm64_linux:       "52c10acf0ed0f693521f837ca3b451c38f2b9425611858a820c2a5aa341ab0b2"
    sha256 cellar: :any,                 x86_64_linux:      "6a9fa836e9e2eea44b758f72b09af2e22a8f1e4f3f6e78f5f7ef2e1b9cab39da"
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