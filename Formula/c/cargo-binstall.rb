class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "e31dc589483bc72d53437d382dc6e3e54d7c89666ce4d998ac3f8e1f11e999c6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3450766521e5b64c15c809b8bc85fc6d95d006de4dd965cd195ed0092e8d5965"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a20b9ab1a5495e57b68926b24836e67704f6d97cd3e9107259b104006841b55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00a327dcba781b26f7f6630174ef45e4a42c3254fa59a391386d6a618c5f60e5"
    sha256 cellar: :any,                 arm64_linux:       "bd5c662cfddf4fee231a329d3ccd290ea8163559b332c09e8526efe73e8ff307"
    sha256 cellar: :any,                 x86_64_linux:      "67f92f8731b3d572e18e5efa7c2d5a6dae5ddf5473771aa886c51edd2768f4a8"
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