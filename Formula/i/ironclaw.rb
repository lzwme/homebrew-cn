class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.22.0.tar.gz"
  sha256 "a21c5ab1f03000812280b1d6d722832df6b8bb8a2838116356bf798e097fe8be"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af4d1ec8fbb2fea63429128c36cc28b4131ad5340030418552af8c6283c5ebd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61fd12607c1ddb1db59529cd280289032e04374c6e06d10574f82a5aedefc440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c7a2f7b78b3af1a78c0f9b629bc7aec9f43a4c5fd14afde999aff35d1ad860"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1ace29791a5603ad72c486889760ab15dc181fa3919e36cddd9203ce525f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac3bb23073ea19a03909623aacd06a1f43195b6a1defb152da22418dd0d0986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2965573a648362e9d68419b7c6a14454460c5c506120f5c1d7539e6166f3ade3"
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