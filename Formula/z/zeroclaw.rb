class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "201e25ac0cbc757d2176291182f3a9e228109c4f92b28ca90122b4beeb1ca826"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c673e1c0591c28be09a239195c8246594cdd55cd32ad92fb9e5612a4a442c2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "569998ef3a8b368155d8f978d5add444ebe4aa0a3b5d7d11dceb65fc62f1d025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bedb2642e3f1d0af65107ab2b19657a09f551176705e23f0aec02b336880ecb"
    sha256 cellar: :any_skip_relocation, sonoma:        "06bead952bfd7da08f50f53a2a7bb0381db499a095785b243ef20eff262c9872"
    sha256 cellar: :any,                 arm64_linux:   "338ce68871284ac932fa1a68db69dc19ec20651802e1f56c254663dd6c556ae7"
    sha256 cellar: :any,                 x86_64_linux:  "41c8b9a8a2442cb1fef598c489ff497e4f74c4dc93f68cea9f0d24a4d7eebd2f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end