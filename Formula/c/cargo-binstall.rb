class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.17.6.tar.gz"
  sha256 "4d03768ef4bd89f387d9a557b6780c492cebb70dbf54fe33400fee8e82dea588"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a36095000447c577d086967233136926b56cb5f56919d0eb8d099a12d44911"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f06319fb5b336e3aa64cbf4a9cb4e30a0b56fb19ef9e9c61acde23238907762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d4f748611de3ee7ab652d35a647013c425392a869547dd9242b42de5913bd9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b3993643526c80f422b6f07bc87b1d566001fd344b3346df2ca5b43fdce6640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d30ba5b5f4524267601a911fe6b438f3a8e5388284c58fe2f254349caebeca5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a13edf701408352838941cefd9dccb98e3614201dee98fd236bc2895be22d76"
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