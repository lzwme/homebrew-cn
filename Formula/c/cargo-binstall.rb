class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "047d3c58be54eda727ae69c23320ee77413f3e508505e8c9a53081d0c213e1f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1dc62eaf999a311f214a645147a679e0541249e375e87eba9368f0882a6114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6558e199ee93a99c66f1c787b47d34a36bc56ffd7921a709d0c473a785369f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0ed48d309951396eac49f68ba6de1a6cd3d6c3bf17595e732585d8e1b474fdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c3094eef017a791fe2a34a1adc86814a9523239f9cc3a1dc47c17ccd3515fc3"
    sha256 cellar: :any_skip_relocation, ventura:       "225605f6abd90c43bdb13b9635179c6f756b27ed26cf4e1ff67caab90d92d614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8c7d5b3d313c9b19279329b985f418afd6e57ae4a6e45bc2721731ac740abfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a877113e45ee2e84976a37e362f3554c1f58be8dd2951d21f66d27c186631019"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end