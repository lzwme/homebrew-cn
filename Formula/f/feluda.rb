class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https:github.comanistarkfeluda"
  url "https:github.comanistarkfeludaarchiverefstags1.5.0.tar.gz"
  sha256 "ed201fbe53f6073e6f2526a3802cbd3a3850fb1a169e97d65f0a5e7cb76797d5"
  license "MIT"
  head "https:github.comanistarkfeluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7cc681be8a5bbcfd728c27251c002cc8b8afca06653c2bb91e10b07147b1f42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c784b53b22902e3b5812aa3bcf76528645a353aa063a7aa43a7ac1da869182e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bec18e07516125db1ff3a4def4081dcb9bee9494d13767ff0957b085a9838ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc1440b5f1e1fe7ad6c965e0f7640d8e10d5e92ef0d1917d6f8baa4a1e6f320"
    sha256 cellar: :any_skip_relocation, ventura:       "4f0ee8967278210faf7a02288d01d65261f8901d338e5be9635a652bf66fc324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab90393101dd0c7025b41017036d7bc83bc5bb71eface26bcd1f348707082e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}feluda --version")

    output = shell_output("#{bin}feluda --path #{testpath}")
    assert_match " All dependencies passed the license check!", output
  end
end