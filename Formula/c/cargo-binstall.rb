class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "d44093c75961becdf663f91c63291f1fa7c35c1f751d281637e393f923f8d8a7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a534cd0ac9eef1986cd38ce1432c261a80004c3545aa6cf1f1f8400a2ff80061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "749097fd5b6241cdca8dfa5f141a2ebf157d654a908bd7fc81af933f20fe70aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09340705471c337392283b4aa4726ea8dbd8f8b69832566d96760fdfead0745a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1103511c9fd3d22faa3675384e46492ea60a359078f3f61015c2c3bd7432fa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebcb0893525e8ac5c42deead0a7169a2fc446d9272c0000396e8f96f035cf97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e38b5d8413707dce9260c40a3b374f26895a3e61da42ce19f06233c53631b8b"
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