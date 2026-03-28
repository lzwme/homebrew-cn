class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.23.0.tar.gz"
  sha256 "0082b11de02407190dfc1db49814af9b35099c5f74cac34896c60ee087c800d6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3fe508fa3f8bbf17e45fbb38eddfe5ef1acb60afa739741712c7910688fdd82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc9eac23e2db088939440929b0fe25b5b6321c8295b501578f080a6e125c6f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99dbbc9befdbddd617265ead04bab2d44790d4596cccd19f3827c3db35e2d1d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "368d1b6f81fe9c1379313171f213a1f78b1ac923739743627e5237080588f93a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "922eec2571fb71f4264fa87c525ef2edecac14e08022ae5af9d13438268b4b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c9496898184a36e688d153cbf8603b4c66886a598b29479c41f50df82de129"
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