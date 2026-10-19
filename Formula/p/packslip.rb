class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://ghfast.top/https://github.com/jdx/packslip/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f34158114ca8ae673c36603461520beeb6755b54886c18dd630f64f4e4331767"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf97dc8dd600b0fdd9e1bcb4bb5423ce7d4b5738bb98b7d96a197de69bdc4070"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "101a04185990b4fcb8913fe57086c027443db128ce445f3f59663e6dd562c176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9633ec725cab82f2333c36b500bc3bd98f1cea17dd755c937eec6b856abd2974"
    sha256 cellar: :any,                 arm64_linux:       "eb177d70b26019673f3a61f8854fcbf42e3c0fcccd6fa317a2f2a308965ade96"
    sha256 cellar: :any,                 x86_64_linux:      "96f660faa28435146b7fd2a940c21c5e0cfa94f79e9c774a511887978353d7f4"
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