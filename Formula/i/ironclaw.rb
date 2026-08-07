class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://www.ironclaw.com"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v1.1.0.tar.gz"
  sha256 "07117026742b1e95fea03d2ce209bef31d3f871aa7ec3a5a4ce9eee8d801000f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^ironclaw-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "583de1da633396cebee33b34f2dd026e730a096d42a40480bf34b6895b91a3b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4afc3ff552d91f35c9983983eae79e890519b514f7526e1eb8aa6ce496d13e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "562d5ab0629cef3554dcef0c85df6563a30e07cd90f59b14da8151a1399fa398"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e264b23690ee6bb26ffc155ce3414591053ef2165ec0228ca90f4bf721c758f"
    sha256 cellar: :any,                 arm64_linux:   "e93cb3a2c9e9c7a18385289328e244ae04b06b7c4e6ae60048b0a264f43049fe"
    sha256 cellar: :any,                 x86_64_linux:  "9ef058013c8820e8053cbb4572f2f8a2d907b13c02b26e771a1cf1babb67125a"
  end

  depends_on "corepack" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "cargo", "install", *std_cargo_args(path: "crates/ironclaw_reborn_cli")
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