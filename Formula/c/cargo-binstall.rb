class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.9.tar.gz"
  sha256 "6587d205fb387697a7ed371c1a73ba9fd2392a165b71ff85f35794f17ad34794"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33613e1052a479bb16b66d2b3c55eae9e983a229ea8bbc9cbc6abc28e79489fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e448c148ed3cfc8c0b72b1ea1be1682fc2ee27019a86ebb986e85acb43916201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "764e7ffa7245e9d8e5081989ececc2b14ac79d9617a215fb3a817374d48ef787"
    sha256 cellar: :any_skip_relocation, sonoma:        "b42cb129cbd111fb95616ae74fb062067d3ab7fa74c55cc8f884493050c76761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048d3836c47d2a638fee648c6322e9ac69b0cdd563b0db04ecc139b41865d5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2446735388a8e0cea3e81e9a62fb3220d8e2475a530b5d315bd17d7de955c425"
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