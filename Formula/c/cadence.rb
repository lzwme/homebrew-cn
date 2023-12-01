class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/refs/tags/v0.42.6.tar.gz"
  sha256 "ed35a7b1ac5c58696a193456713c388c223b163dca27daf9becafca7e1c1979c"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8eb938aa7c339f096c408c84655c5f383a280be18e42048fc542cc0b39b82503"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "037b4a7152e0e2b23386205add9b63fceeddeb5cda3a4be2d181dde2db31c54a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c04ac3845d350f081677d713da35d25871ff7edc36e5df92b78716f2f407414"
    sha256 cellar: :any_skip_relocation, sonoma:         "73115f6e2236bd88c5e816fe85f80496bee5b6e33c121aed1e3eed72d34fc04a"
    sha256 cellar: :any_skip_relocation, ventura:        "99d8db317c065a0d58e73b902a8e42088a55b1e5bcce70638f878addb884439e"
    sha256 cellar: :any_skip_relocation, monterey:       "1c2b4a511b370825f4d3109c50d00befe04c2a29264f711445da04c61bfa9d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "292cbd43a525b82439a1e1d0b5cb06d65002d396dc621707f3e4ffc8d3a8d3d4"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end