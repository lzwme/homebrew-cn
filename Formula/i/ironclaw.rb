class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c16eeec2279b6ea387c7888c02e3e6874a653d8ade8975e90fc5a01ee456bf89"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af83556e683dd800e1edd743618b1f5a6d8d7e08e6cc0d98092e48d809963487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "154ab3e5fa688e35dc5c64cf74e60688628df967297f55b94cfd2168b83e1358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0ed54cfa63be710625fdbace38010e4346eea9d1b7268ec25409b1745d7031"
    sha256 cellar: :any_skip_relocation, sonoma:        "0981b85d0e8f0f09ee354b0ed427a43898ccc19d6ab42790cc99b3380ccd591b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02dadc988c542c5f6e3ca1990719a36286687b0f753ed179628ecd9efaf8b7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a53d58c6f71d5007c16c3e1e9962652c9ca6d08a8d5c73274b24fe797b1886cb"
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