class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "b8fdebfbb8bdeda91062d69607227e56847258907dc38038c7e6bce874b00c46"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c181ebe8f239353c4aa9de17353a5678a5e8bf96023ed260ec6f3c577bab0c4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae2c04c42fdbd379acca3afde0913bdbf477926b1bb98e093e5f0891aa2ba7e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5df306c1d70056522be18932a906406ff879cddb2edac814947e409cda6a776f"
    sha256 cellar: :any,                 arm64_linux:       "5917c7d2e48f9c375bf0e4a9a119ec3a279694f8f509211090bd212a4815cfca"
    sha256 cellar: :any,                 x86_64_linux:      "c35604eaa0cc1bb972d79293db3f79680acb9742619994eb0fc3fec42ef14fd9"
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