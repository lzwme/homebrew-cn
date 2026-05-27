class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.29.0.tar.gz"
  sha256 "3657c9928b6bd81e285783a610a0bc7ad71a2e6aa2e8780452c72f1931260539"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bb0cdbb4fca0f623d3d5d18934bd435b7fb6cc4938385e2cdaac0c6f1830689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6b3f1f7f8514f636c405e70c67e8e19352b1425642770ff6a11fe0d568d5ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b3514fcc131a7ffaae67f7bab42da35f32dec5b5dd46c7a45ff39c7d0788d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "603ecfe1dbf881523a83fbc055453bc2e573962bebdc1b3b5fdf9695d169e58a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c064ed8b1bc92b4ce00cd2b2d2bee8b823126f16347b0c91478606812d5b1767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c891d3d65154d77360f746c656df16a00f28a52fdf0a1812e9b652e8548856ef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Missing required configuration: DATABASE_URL", shell_output("#{bin}/ironclaw config list 2>&1", 1)
  end
end