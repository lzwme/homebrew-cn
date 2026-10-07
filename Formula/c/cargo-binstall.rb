class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "77b17312c655720977b8debae624c9983c735f74e6b60eb51492cd245fe74ae4"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c846b884e0bffb02f719a8ea7d58892551ff3aaac7fcc6002f23bb40435c2699"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b20b6918275abd5e83666f3a12a68810f79bb4f0d3d0ff7506177bc31313cc70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1dcd48290f83b8ba1c51dead7004285317e93a5404cb1a05f47706bd8fd293a"
    sha256 cellar: :any,                 arm64_linux:       "02db50b01f442dc655b758520dc2dc1cdfd2fb4ec59dab90b101d9de49abe5b2"
    sha256 cellar: :any,                 x86_64_linux:      "86f7aaca78a5ca9665daaa0baaa774340429e0b486071ff3be1f865a93c495a2"
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