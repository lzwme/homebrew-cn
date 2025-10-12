class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.7.tar.gz"
  sha256 "29564a853e8dda291cfd45c83b31f02b8fa60ce1f0c45f808b4294421c5fca31"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e731d2f574757e02d750e19200c102d7cb3fe654cc5bb15a29d065442bc531ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15baac7a0d799ab0dddab0da1332600a7a1b4c2c4c717714dc6eb5bc6e4630fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25fe952f2e459b2cd24e1d9b72ffdb8440eb617a88ce4d77e3dad4ce5081ca88"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb2270e165a0c1813b85114a8c4f2d1114d308bac43078a4aaf202909c4cc60f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e358863085fe4e59b3cb52d5551671e26e27aac392c4a373cd3b823fa1886ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3abb21436cfef06ccea0fe130d24532606194ab187a0bf71fd17140bcac915f"
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