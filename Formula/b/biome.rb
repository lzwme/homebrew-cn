class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.5.tar.gz"
  sha256 "39c685ea028d5dd8db101b93c96a0956fb6f7846da93caa49231a62c612daa77"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1798ed14b766aa0e13a2ba14930d365922c8d5d389a59c5700c458f558e310a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c71241580287a0fca4adf90fc1642e5c6eecee5ee6acf2b61d88773efea4122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44283e3c5c16d8d1f28c91663650058d364d9aa9b6ae850a17d1b7bb631d7612"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d38b2a2920b22953f65fad07051e9f3b5e35f5bc22fb122b437957f04c5cf60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6ba3ed84b6c3936ea265f5a4e9aaa839239d9a10770ebaf80f8b3ff2cad22d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3120a76fad91b48bca1a740d985c566d23ee9df06c78957949134c9ef535e28"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end