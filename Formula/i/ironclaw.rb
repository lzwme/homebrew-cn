class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "26b78c98f3faad3fdd35fe34924cf6b253341f5278cdc89320b8ba66de953a4e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcb37e48fa52c4ece68b0ada61fe4f1ed7b84c3b15ebb58bb6c5655009ff0f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41585e4833dfe793b136385f39a29295fc4f2cf4fdd71e74056206c3acb760d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9cd328b667287a077ead20dc6df1a95f33f8e2c49bfaf0156636cf6588df076"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b4fe693eef169cb035af4556caa6616c6f9df698267416f43a90e6c153a06f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9657d6ccae63304e62c8109315177efc091993b791531a4b612cae0948d9579e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d11ada589c32fb0b1557a1cce8a7f5dcafd8985024942e5d77ebd40b9d7090"
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