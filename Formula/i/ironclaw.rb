class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "802a1b0b4fda7fbc599f8423319c90b61b27f742ac02e2f7be6e5e1e36a616e0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "143c4c13ea57c5a07c8a8d7699072f2797af8e22e7e808911e51df13792f13da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0cd9ee866ca752752cdbb61c93c95c769abde6eae4ae5886bbe4679bcaf31d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07f2b7c61696f42ffd8935d0716b49797511063f6713754ed4f449e933da67bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "20adf08ccc99cb397c8962ced86e0521902bb73bb95696af4b06c836a5d6778c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba56cc8360f6511526351b2c3a7d332bd7c4c19c83f38450f0909f58d0467a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb977cf5098ae97251df7121e9c1d91c10e13109402d9e04af9caf14a7804b40"
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