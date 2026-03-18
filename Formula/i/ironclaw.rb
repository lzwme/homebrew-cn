class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "7a8ba0b92a534669bb27438fb2989a53ddb0e47eb52a8154fd1feeed2b2014b7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da7f60fb96b9abb8289a211c33dd0e9c1fe54f906189b417c013f8e34605d54f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2dde238df658eba939c5563349143054c5ad0d5afa47267250b206f881f141e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa5ac5195183bd6b63590c2f3119bd8a8896c25000410cff9115b8e6622a924"
    sha256 cellar: :any_skip_relocation, sonoma:        "598612e8c3c99f3a9aacf38d695ebb0eb6aefe958a6a1a57949afe6f8271c4df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2394571f81ee47a5e246d4c631020fc8b5592b67e1ec92099ce0d21841feb5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a5b448c94aa028be8f7b7e76048779b5e8aab4303089826e499c8d93191778"
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