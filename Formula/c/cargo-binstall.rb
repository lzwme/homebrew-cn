class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.10.tar.gz"
  sha256 "c98492ab03c10aa2d51a3846c0fae7e0fc7a35221114f6c1d2ffbd48b584720d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4d1eb8831595a82a22a07b1204431bcd2d23a83da1cdd610140dbda7abb766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66cb42a988654fcb334c7af13f856c9f5dc22dae9575230f1868872b7474a6b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52410547722227c0dfbffbc9b5c63ec9591c1f9e5497bc508d1fe2f9cdc5e7ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cad1e966e0b2e4b3ab45c32dc06951dc96f919dc9ee8d78565bc786db6f72dd"
    sha256 cellar: :any_skip_relocation, ventura:       "86897a20b46846d7a6ed172733c541c23c8541e3cf1000569e140b4ee64b625e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dabae970a6380098f6000e07e89d3cca83e537702514d11a4df45ca08802070e"
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