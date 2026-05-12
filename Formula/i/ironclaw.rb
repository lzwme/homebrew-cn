class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.28.1.tar.gz"
  sha256 "5f9dce9b86ff123d91fec7d26fc413eb2f8a15199283ef1fcd6992e8df5ac6b1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46576a153935de516496b689876fe6f186da63de1e80b7d6c6aabe8539928997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e660cd933c224e55f8cea2176431a86a8d4d779ad6c1ad005715a050e104e86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb7a83d3e06d5860fe1fcdfe4b925b455e22ab4e8eb26cb4ce1888fd2682ba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4fa60dbbc3d7894ec5b623c5bc77f22ff96b652ce4df7b7f7fd1305960f910d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e7c5a80332932fb3fb5fb043cafc2e6f784f8f5eaac42585c743261482b4351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce41437f0615262872b50cb867374c0881e1324e38d40b9d7b943223c1c987b"
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