class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "862ff87fbacc030c065cb342217fab07e6826de05e0549c51dd306e2e2c5033a"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24310c9d86302c73ddad3ed89e823bc71a47ec3d7280175ecc8480f4d530ec61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c5b89db2e36bab2949cba5fc505778a12fed7e9b34fcc58744ad761eeb07e27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7520bc842137db0d690857ea3a124a286b46e0e966b8e7035b7013439923a84"
    sha256 cellar: :any,                 arm64_linux:       "76dcf23ac06d8ae2d334b50445b10cf431391de921cff39b4b5601f3fb242687"
    sha256 cellar: :any,                 x86_64_linux:      "9c20749a29e2fba376e3ebe4f11bbd2149509410aee0f4eb4441a16e3092b219"
  end

  depends_on "rust" => :build

  # `test do` block resolves a crate from crates.io
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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