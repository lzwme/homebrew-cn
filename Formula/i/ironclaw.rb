class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "f8b7fd74bef8adc467448922d5f84c2f78db4f554886dd074fb2eafd8d5b4807"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b9fe80bfcbb1c3cb6cb357ad4f36dc0d1e0035071a6b8e60361b77d24c23fd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa894ef92305a14e24699485d542f5a6ee92d0cf6b83a0a3eabd37e69ef63307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ee18c1a8924c9699b96d3636ab32b43aeefaedc6da57f32c83b509c71eea1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbb56a8bc360be7bc28db1708c9dcac2f6840848c73ea66d52d1394635edca55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32053b0906add469e4bb9d60bb907372096e93e7f79c239752113928b613474d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23b0057f8625599801a6fdf253b4419c97b2c8ce7e70751d86457f092f1c7b3"
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