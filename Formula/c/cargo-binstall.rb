class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "dbd172618a15ca38f4599d97a795f89cfdc0251c215853d38b755f4f4a771892"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a40d61dbbaf911a7f3a8447f91ffa9300ce1549aee4be277d258fb398e7af9b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d20f2a1f06b3704d6c795d9027892944d4975e6dedbef8d30d159599b6aea16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6ddc29921eb1e9316188543337e1951cc175ad8b6d8d22362643848a7d205c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "735992b9efad238cccb24b00a143cba5396e9f2f8cfc6346f14344459e1a3f7b"
    sha256 cellar: :any_skip_relocation, ventura:       "c0069e15ccc9f45f5f0813e920a1c3b272c7fd9a88a621eebc2758168d3c9242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b951f6f535a2fe5fb9234c3a1b8e5cdafa542ad4a92f00aa29e550606a745d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7801341da957caf6389a179045d8482ced2f5c247f2311089cc9aa9ef2263bb8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end