class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "959bbcea161282c757ba601eed0b418be06bd269065fc7102e7a8d8be5f07f6a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "300678aad9699725da92d4f8abc97d3da78332172ceca71f3248c98cf688cfa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e229f39331d2a65aaf8f807f89ec7ed7990e391a1cb706eb02ec510120222097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0191412abfe75ae07a1e803eb2ac952cb3af09f34bed96b785d606d50217f642"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7a8d80d09237c2a46f28671af22cb1faaa34ee7e64700233c32955f795efa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2078cf561f753c59141e984f97be4c3608a61f13e139ad25ba861a49733f8167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a49ce2b36a548b326eda20eadac965f8d232e558da6bb4f41a3065370c90bf9"
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