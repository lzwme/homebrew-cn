class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "4a570a613cece4b831f1d00fa16e73100542d067df9415e5a560940f0e0911cc"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76efe080fc58f2a901ffbbd829fd92e275d51d80295d8a3f1e5123d538aa9f74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb0fc72bc7f19dd00b33abeeeafd5f7464fee58e568fe17e49a74ea15b2ae7c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15ae62bd9c329e1ee56db0cb46ef4d20e92203405c0b63da90527e97a5a0dec2"
    sha256 cellar: :any,                 arm64_linux:       "23ddb5da2bcc89c7826748ef4822d9751878c036171f85632d2e2988f564147d"
    sha256 cellar: :any,                 x86_64_linux:      "013be1d2754fbb40d0b3d7fe94252da27759de3e21205cb95b4101b9fdaa5887"
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