class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "987d0fb0e85ef8146e9b304d849457fd244d924816b7a5974353d38cbfd8d9b4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65e2605a2afd5199a403d61bd6d095b4bf78ef309420c4b6ec5f171c5c10d9a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a45a2dec67804852497847ab0e91b84424e9a4a7b66ec5816bbff408299dc60b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebdb211ac56d09ec7c9890d660baa724d27b7dc199ea7e193a064b964d84c6b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "aecb1560d5d3816d85ac1361a94d09c7491b041e25faf2bf2c602ac43e9b69b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "388a7bd4755248db33ad5368e91415536135167ed1402337a5886ff3ad754ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fbbb0a279b25072e2e89c6a4b078b524e239e70e6667077c337786476d5c847"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end