class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.12.7.tar.gz"
  sha256 "29d83fdcc0b2a7815f8c82783340b90c61abd7e2c1ce0f98e054b6f3baaf8a81"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d662e650a6bdff72990d248316eaf2bb95ed0cf70ef1addbd9588e42bd43302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6cc8b7f4a72b5da0c8825a6bdbfe49fd6951823ca2a201988ae96a4e62e1c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13a32a37390078e8ecf225ea58180aae81efb2a3d82224b3cdbe4407c4855c71"
    sha256 cellar: :any_skip_relocation, sonoma:        "52f95d65f92ae68561f78d9435b148e3f4626c9026f46dbc97c5fd69ed2cb9f4"
    sha256 cellar: :any_skip_relocation, ventura:       "79a21b685dc56a3f6d759f3bda7ab6e685d9c6a1e228bc2568761d2b2b2a5500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d9a1a1b08ff1b1a250f375dc322ae0e54406dcac4fd42619a224c4d47ca5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f539909e3b5ea0cb69d9c574efa2c0f728f1d29a0071beb5dcbfd61fb54475be"
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