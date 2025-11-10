class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.11.tar.gz"
  sha256 "d78ecc46e47e7c96663285ac6010fa352a1ea3630816a21903bbcd407ab97c01"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e10d5385560f517119835755ff356a068745786203bea637cebfae29caf46dc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831c6b59dd3a89bfa911635f542fd6fc6d82f378a2f2f108a6e46dfcd2794480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54cb6061cc2c7c01f21315190737b9d8eb16099dc6193536b8f4934a4a27e66d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c4e3204583a6d8a212656011f3a86bba0ef7e8d8368d8ca7620808153bfadb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72d28d539af9e4d60f04dd7a97a588850d7b807b3b6bc82bcbb9cf06d0caf10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a0bf63d8172d53783fc14000b0b37d330aac6926f4f70460e2f985192b20d4"
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