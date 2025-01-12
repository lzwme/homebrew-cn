class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.20.tar.gz"
  sha256 "398b71818d61f2a81971fe3f65999bd60a04b9615a038a384e1c28c8e6dc6a8f"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "643c51e50f4734af725541ec54ce6a7354ecf34aeaf5a387051c68cf072473da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a7690be5bd5f5eeef53b024a75c36284b5ba4974f190317d04c5aed9b81c863"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "752b783089251c8610a13ebb7787c8ac408cee6b2659667c412f22eb369e0526"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c49dabfc9f1ef651ccbe9980a0045241696daf1e0e830514b76163a54ab1b4a"
    sha256 cellar: :any_skip_relocation, ventura:       "76c07f563ab2e8d25cf7b96847504665018bc94e90bfccc87560ba561508393d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1459f787009f50d8073e9028aa3758510796b5a8e140ca45c971d51f1ea165d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end