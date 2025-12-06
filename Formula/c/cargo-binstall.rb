class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "48fae7e8b02167913a46b4184034ce48a0772b0e08aefda11539e2ac83c719a3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6578c070163db168af7e95ab08eef1d71a31649724bbc2f6448fda9634fa733f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b365cd597999b5171ebf5364346476abf17438ef249705cbd3dc2d0f41e4412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8fa015efbb1810f7071ec04023c60819dbd501e92c14e75432bbcf4e9b3aa72"
    sha256 cellar: :any_skip_relocation, sonoma:        "da8b2f380f549ce645587e7fc0c8284a724662069113ad642c62d8975f56ce42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c3566e7d2cecabd5f89ba7c2c97465c544b2250eace5241c4038e050b042fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69efe60776d1c93f35a78375499db8f3170e8b81353ceddb9f66fa098c3f0a14"
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