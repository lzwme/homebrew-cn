class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://ghfast.top/https://github.com/jdx/packslip/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "93541f7f0313372bdd269e8163cf4388253a2199a14464d0a61469a7d932a1f6"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e8f833bff249639d71a0014e6775f32158374547b8d5546657ef3850202f22a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37f3082c71d57d22ee54e9321c9850475a8841a157749640917a3fa4991693ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b31a5afff921851ffa6bb0e44c2e39adc07b0f8af6c96d09159d2fc4ec970b7"
    sha256 cellar: :any,                 arm64_linux:       "2d0c9c9a9519d02390bffddf17c050f37487d56735064eb76810cbe1f0dcc87a"
    sha256 cellar: :any,                 x86_64_linux:      "798257258c7c13b53918368e48e5b23db227f664764483e4a83b177a51bac197"
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