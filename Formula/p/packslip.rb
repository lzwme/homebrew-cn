class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://ghfast.top/https://github.com/jdx/packslip/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "7b4e22b0d43878bcc28ff703f9b90a03a38b38d3f825ef2b996e5557ef4dc15a"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b805eb77b4dc843b5b434d44943152d1eb7c23758dae6c6e986bfc39eebd12a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c1498ca9281da7fb001aa4461302d34668519d95d5a3466c5028460f06c2502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "669383ca22d1eec6f6d638b385b846f92836e833f8ed8423cf90f3ddfd8e1b45"
    sha256 cellar: :any,                 arm64_linux:       "48eea42f00e45f2e330d0f993c2d93f266c86192013c222a0622bce36a69d0a5"
    sha256 cellar: :any,                 x86_64_linux:      "a09a2537b6627b06d4df11de588eb02adb8057cc77b8196db5a8da34996ada72"
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