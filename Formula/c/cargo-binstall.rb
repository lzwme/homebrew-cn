class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "cd1811080d5c5fa180bc436c1da893e00a7a492baa871783b1b2ea9dc2488347"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7336e6074a7be89f4c103df615f1617634a5a21074cdce3ca67b0cdff61de244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e0f2442b8d9344fbf6d701c0d775e04e6aca269d5fc5b669d39a85db00ca74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a41b2817e562f5361f4eccfee55485b3769d9c87bb72417c0abc31ff18058b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4a2d7a6872f4587409f25f89fcd3264e38aa92dc64d7c462e389061b8ff4c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb253614398eba37c26a2cc471e5f779addb9c4caf9c780beedf232cd326dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92b3d831dae6c0425eb40873b3e4f4c39aab75c6e99cf1d0c4c205d4f26b661"
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