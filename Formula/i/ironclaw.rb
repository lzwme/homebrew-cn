class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://www.ironclaw.com"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v1.0.0.tar.gz"
  sha256 "34e4ac8f83a6368acdc795f8fd0643729b941686c002b7facd6128214843ebe7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^ironclaw-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e47c357f94b7c0144079fbab1bb688dacb2ea9a2fdec82cf078a66d1e115126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad81b23bfa770f924b042b6c7691094dfc8915c336b8d5c2195da3a7dd404c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447a285eed877466209b73c9467dfa1b4a35a211485a8bf6653e17cc0d4d5211"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e98b26c34c71bdcded97ba6ee5538e60bdeed7d5726d0e9fe46814f416206ab"
    sha256 cellar: :any,                 arm64_linux:   "52d47422a8210f2b4c7e1a33a49d9d81baa1c6c2b53f37af109fbc7e23e8f7c4"
    sha256 cellar: :any,                 x86_64_linux:  "2ba101e015957dc03913cec2c8e6d1a39fead9d6f10b97113bf6e733c94981e2"
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