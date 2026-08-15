class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://www.ironclaw.com"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v1.2.0.tar.gz"
  sha256 "4d64c4fce52fadf47b7d793d24d4e3085f68fe3fb7395a9d6fc1e5ddc9fbf8bb"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^ironclaw-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23f272e0d41df365b7c80f33fef8397d95f30b6b9022f20c40c5251ff01cfc80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a4ea1ae7e294c6f00499998525c8cd741b054ae2608b88acd725a2c686cea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aea65fd01c6d0ce34b9c875414f0f5057114f6344d0da9c46d0571fe7d9c2e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e04f588cfa25cd528780761227e90919a5d75b010a031fb6cd9394be7c088447"
    sha256 cellar: :any,                 arm64_linux:   "29dfcc86e0caf9e942d6067922bda2e835c1079a193e86a84f2fb852635942cc"
    sha256 cellar: :any,                 x86_64_linux:  "46b61fab36d5caca43671c1c98652849a238a275dbefd884467506e4fd05a1f8"
  end

  depends_on "corepack" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "cargo", "install", *std_cargo_args(path: "crates/app/ironclaw_cli")
  end

  service do
    run [opt_bin/"ironclaw", "serve"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")

    ENV["IRONCLAW_REBORN_HOME"] = testpath/"home"
    assert_match "IronClaw Reborn config", shell_output("#{bin}/ironclaw config list")
  end
end